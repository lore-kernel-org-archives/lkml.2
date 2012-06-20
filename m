Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2FTKdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:33:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:56379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2FTKdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:33:22 -0400
Message-ID: <1340188391.21745.99.camel@twins>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Wed, 20 Jun 2012 12:33:11 +0200
In-Reply-To: <20120620102747.GF10012@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	 <1340121811-4477-3-git-send-email-bp@amd64.org>
	 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
	 <20120619232857.GH5996@aftab.osrc.amd.com>
	 <1340182778.21745.75.camel@twins>
	 <20120620095616.GB10012@aftab.osrc.amd.com>
	 <1340186931.21745.90.camel@twins>
	 <20120620101943.GE10012@aftab.osrc.amd.com>
	 <1340187720.21745.97.camel@twins>
	 <20120620102747.GF10012@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 12:27 +0200, Borislav Petkov wrote:
> 
> But if we had a script which would split it and we had it in tools/,
> then all would be fine, right? 

Yeah.. I guess so, but what is 1.2MB in this day and age.

Do put a comment in microcode_intel.c where to find this tool, even if
its in the kernel source.
