Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2FVS7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:59:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35092 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab2FVS7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:59:48 -0400
Message-ID: <4FE4C010.3020005@zytor.com>
Date: Fri, 22 Jun 2012 11:57:20 -0700
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
References: <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620095616.GB10012@aftab.osrc.amd.com> <1340186931.21745.90.camel@twins> <20120620101943.GE10012@aftab.osrc.amd.com> <1340187720.21745.97.camel@twins> <20120620102747.GF10012@aftab.osrc.amd.com> <1340188391.21745.99.camel@twins> <20120620110914.GA10771@aftab.osrc.amd.com>
In-Reply-To: <20120620110914.GA10771@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:09 AM, Borislav Petkov wrote:
> 
> Yeah, both should be workable. Let's see what Intel wants to do: hpa,
> Fenghua?
> 

What we want to do is to have a unified binary blob (which would be
about half that size) but the format may be affected by Fenghua's
ongoing work so we're not quite ready to rev the format now just to do
it again.

	-hpa
