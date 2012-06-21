Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2FUX2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:28:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2FUX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:28:53 -0400
Message-ID: <4FE3AE18.5050903@zytor.com>
Date: Thu, 21 Jun 2012 16:28:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-1-git-send-email-bp@amd64.org> <1340121811-4477-3-git-send-email-bp@amd64.org> <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620230856.GA4223@khazad-dum.debian.net> <1340267075.21745.155.camel@twins> <20120621095807.GA6437@aftab.osrc.amd.com>
In-Reply-To: <20120621095807.GA6437@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 02:58 AM, Borislav Petkov wrote:
> On Thu, Jun 21, 2012 at 10:24:35AM +0200, Peter Zijlstra wrote:
>> This thing is not installed on my machine, nor would I have know
>> to look for it. Nor does apt-cache search iucode_tool suggest any
>> package.
>>
>> IOW fail.
> 
> FWIW, if we agree that we need a userspace tool for massaging Intel's
> ucode, it should be in tools/ and it should be very easy to install even
> on a distro which doesn't distribute it.
> 
> Emphasis on the initial "if", of course.
> 
> I'd very much prefer tool-less ucode application.
> 

We're working on fixing that, however, we want to close on the early
ucode stuff and have it work first before we make any changes.

	-hpa

