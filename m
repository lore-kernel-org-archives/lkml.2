Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1CRMj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:39:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57036 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1CRMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:39:22 -0400
Date: Fri, 18 Mar 2011 12:39:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Message-ID: <20110318123917.GC27129@sirena.org.uk>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com> <B85A65D85D7EB246BE421B3FB0FBB593024C3B85A5@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C3B85A5@dbde02.ent.ti.com>
X-Cookie: How do I get HOME?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 05:29:39PM +0530, Nori, Sekhar wrote:

> PRUSS as an IP is not really tied to the DA8xx SoC architecture.
> So, can you please name the files ti-pruss* or even just pruss if
> MFD folks are okay with it?

This...

> > +EXPORT_SYMBOL(pruss_get_clk_freq);

> This looks strange. Why do we need this? There
> is clk_get_rate() API in the kernel would would
> seem more suitable.

...unfortunately conflicts with this - currently all clock API
implementations are unique to the platform and there's no way of adding
clocks that works over multiple platforms.
