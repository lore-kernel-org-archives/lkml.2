Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2FTXKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:10:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42580 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2FTXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:10:54 -0400
Message-ID: <4FE2585A.3000505@zytor.com>
Date: Wed, 20 Jun 2012 16:10:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-1-git-send-email-bp@amd64.org> <1340121811-4477-3-git-send-email-bp@amd64.org> <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620230856.GA4223@khazad-dum.debian.net>
In-Reply-To: <20120620230856.GA4223@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:08 PM, Henrique de Moraes Holschuh wrote:
> On Wed, 20 Jun 2012, Peter Zijlstra wrote:
>> On Wed, 2012-06-20 at 01:28 +0200, Borislav Petkov wrote:
>>> which makes me wonder whether we still need that OLD INTERFACE.
>>> Henrique, any thoughts here? 
>>
>> Yes I need it, I've no f'ing clue where to put the ucode image so that
>> the whole firmware mess can find it :-)
> 
> iucode_tool -K <name of intel microcode .dat/.bin file(s)> will do it
> for you :p
> 

I'm wondering about the new format... it seems to potentially make it
harder to do the proper retaining of compatible CPU microcodes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

