Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2FZTv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:51:56 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35364 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab2FZTvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:51:55 -0400
Date: Tue, 26 Jun 2012 21:51:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120626195150.GC28495@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <1340280437-7718-2-git-send-email-bp@amd64.org>
 <1340380019.18025.82.camel@twins>
 <20120626194043.GB28495@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626194043.GB28495@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 09:40:43PM +0200, Borislav Petkov wrote:
> > +	put_online_cpus();
> > +
> > +	if (pebs_broken == x86_pmu.pebs_broken)
> 
> This is strange, why not:
> 
> 	if (pebs_broken && x86_pmu.pebs_broken)
> 
> ?
> 
> > +		return;

Ah, nevermind, I see what you're doing here.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
