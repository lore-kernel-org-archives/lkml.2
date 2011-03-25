Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1CYMId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:08:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34889 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1CYMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:08:32 -0400
Date: Fri, 25 Mar 2011 12:08:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 09/10] mfd: Cleanup irq namespace
Message-ID: <20110325120830.GC22502@sirena.org.uk>
References: <20110325110939.701487744@linutronix.de> <20110325111218.440617746@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325111218.440617746@linutronix.de>
X-Cookie: To order, call toll-free.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:12:32AM -0000, Thomas Gleixner wrote:
> Converted with coccinelle.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but

>  #ifdef CONFIG_ARM
>  		set_irq_flags(__irq, IRQF_VALID);
>  #else
> -		set_irq_noprobe(__irq);
> +		irq_set_noprobe(__irq);

it looks like you also need to update the set_irq_flags() naming.
