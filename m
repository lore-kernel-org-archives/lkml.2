Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1FGKty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:49:54 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49913 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1FGKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:49:53 -0400
Date: Tue, 7 Jun 2011 12:49:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: 3.0-rc2 link failure in APM
Message-ID: <20110607104956.GA29447@gere.osrc.amd.com>
References: <alpine.SOC.1.00.1106070853520.18451@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1106070853520.18451@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:39:38PM +0300, Meelis Roos wrote:
> ERROR: "pm_idle" [arch/x86/kernel/apm.ko] undefined!
> ERROR: "default_idle" [arch/x86/kernel/apm.ko] undefined!
> 
> Seems that apm module has 2 unresolved symbols with this configuration 
> (made incrementally with make oldconfig over time).

By looking at 06ae40ce073daf233607a3c54a489f2c1e44683e,
CONFIG_APM should depend on or select both CONFIG_APM_MODULE and
CONFIG_APM_CPU_IDLE.

Adding some more people to Cc.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
