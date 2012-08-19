Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2HSFQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 01:16:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2HSFQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 01:16:04 -0400
Message-ID: <5030767C.1030009@zytor.com>
Date: Sat, 18 Aug 2012 22:15:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com> <1345277729-8399-3-git-send-email-fenghua.yu@intel.com> <20120818221252.GA32120@khazad-dum.debian.net> <3E5A0FA7E9CA944F9D5414FEC6C712200778794E@ORSMSX105.amr.corp.intel.com> <20120819043504.GA9773@khazad-dum.debian.net>
In-Reply-To: <20120819043504.GA9773@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 09:35 PM, Henrique de Moraes Holschuh wrote:
> On Sat, 18 Aug 2012, Yu, Fenghua wrote:
>>> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br] On Sat, 18 Aug
>>> 2012, Fenghua Yu wrote:
>>>> Given a file's name, find its starting point in a cpio formated area.
>>> This will
>>>> be used to find microcode in combined initrd image. But this function
>>> is
>>>> generic and could be used in other places.
>>>
>>> Shouldn't this (very useful) feature get its own documentation in
>>> Documentation/ ?
>>
>> Yes, I can document the feature. And if it's generic and useful, this
>> function could be put in generic kernel instead of in x86 arch.
> 
> It is useful to override/fix all sort of critical firmware-provided tables,
> for example.  ACPI table overrides should use this new cpio-based scheme as
> well, and I recall someone wrote something about device tree overrides in a
> past thread...
> 

Indeed, we already have those two users already identified.

	-hpa


