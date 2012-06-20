Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2FTLJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:09:20 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:46179 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FTLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:09:16 -0400
Date: Wed, 20 Jun 2012 13:09:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620110914.GA10771@aftab.osrc.amd.com>
References: <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620095616.GB10012@aftab.osrc.amd.com>
 <1340186931.21745.90.camel@twins>
 <20120620101943.GE10012@aftab.osrc.amd.com>
 <1340187720.21745.97.camel@twins>
 <20120620102747.GF10012@aftab.osrc.amd.com>
 <1340188391.21745.99.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340188391.21745.99.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:33:11PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 12:27 +0200, Borislav Petkov wrote:
> > 
> > But if we had a script which would split it and we had it in tools/,
> > then all would be fine, right? 
> 
> Yeah.. I guess so, but what is 1.2MB in this day and age.
> 
> Do put a comment in microcode_intel.c where to find this tool, even if
> its in the kernel source.

Yeah, both should be workable. Let's see what Intel wants to do: hpa,
Fenghua?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
