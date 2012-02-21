Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2BULUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:20:54 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60732 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2BULUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:20:53 -0500
Date: Tue, 21 Feb 2012 12:20:42 +0100
From: Borislav Petkov <bp@amd64.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: Remove wrong error message in
 x86_default_fixup_cpu_id
Message-ID: <20120221112042.GE14274@aftab>
References: <20120220171705.GA17069@alberich.amd.com>
 <20120221102725.GC14274@aftab>
 <4F437A71.6000402@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F437A71.6000402@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 11:05:21AM +0000, Daniel J Blueman wrote:
> The check and fixup wasn't needed in the Intel path thus far, so
> wasn't added.
> 
> We could specialise the 'if (c->phys_proc_id != node)' test to check
> for x86_cpuinit.fixup_cpu_id being NULL and drop the default
> override, if that is preferred?

Before that, why do you need that check in the AMD path at all? Please
give a more detailed explanation as to why is it needed on the AMD path
at all.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
