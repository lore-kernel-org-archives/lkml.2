Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2DZTME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:12:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2DZTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:12:03 -0400
Date: Thu, 26 Apr 2012 20:11:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@ti.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, j-pihet@ti.com
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Message-ID: <20120426191159.GA9415@sirena.org.uk>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:10:31PM +0530, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
> 
> AVS(Adaptive Voltage Scaling) is a power management technique which
> controls the operating voltage of a device in order to optimize (i.e. reduce)
> its power consumption. The voltage is adapted depending on static factors
> (chip manufacturing process) and dynamic factors (temperature
> depending performance).
> The TI AVS solution is named Smartreflex. 

What's the relationship between this and existing things like devfreq
and cpufreq?  It'd be better if the changelogs made this clear and
provided an overview of how all these different subsystems are intended
to fit together.
