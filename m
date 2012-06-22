Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005Ab2FVDTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:19:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55364 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab2FVDTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:19:30 -0400
Message-ID: <4FE3E428.8080207@zytor.com>
Date: Thu, 21 Jun 2012 20:19:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-3-git-send-email-bp@amd64.org> <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <4FE26155.8030207@zytor.com> <20120621100721.GB6437@aftab.osrc.amd.com> <4FE3ADDF.2060908@zytor.com> <20120622025631.GD29505@aftab.osrc.amd.com>
In-Reply-To: <20120622025631.GD29505@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 07:56 PM, Borislav Petkov wrote:
>>
>> That is orthogonal.  Anyway, my only concern about the request_firmware
>> interface is that the timing will be inherently wrong.
> 
> Timing? Please elaborate.
> 

The request_firmware will happen as soon as the driver is loaded; with
the early microcode blob scheme the driver will need to be built in and
so the request_firmware will happen, redundantly, immediately...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

