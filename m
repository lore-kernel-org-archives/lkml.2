Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2FSP55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:57:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53678 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2FSP5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:57:55 -0400
Message-ID: <4FE0A160.9080103@zytor.com>
Date: Tue, 19 Jun 2012 08:57:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
References: <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins> <20120615125240.GD6083@aftab.osrc.amd.com> <20120615165231.GA9169@aftab.osrc.amd.com> <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com> <20120619051116.GB31591@aftab.osrc.amd.com> <1340093864.21745.6.camel@twins> <20120619102250.GA787@aftab.osrc.amd.com> <1340101568.21745.37.camel@twins> <20120619150619.GD1427@aftab.osrc.amd.com>
In-Reply-To: <20120619150619.GD1427@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 08:06 AM, Borislav Petkov wrote:
> 
> Now we load the ucode driver very early if it is built-in (look at
> printk timestamps):
> 
> [    3.651275] microcode: CPU0: patch_level=0x010000c4
> [    3.664943] microcode: CPU1: patch_level=0x010000c4
> [    3.670177] microcode: CPU2: patch_level=0x010000c4
> [    3.675407] microcode: CPU3: patch_level=0x010000c4
> ...
> 
> and then later, when we have userspace, we can use the reload thing to
> re-request microcode. Which is also fine, I guess.
> 

Right, although we can push it much, much earlier than that.

	-hpa
