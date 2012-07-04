Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2GDPY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:24:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44364 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2GDPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:24:55 -0400
Date: Wed, 4 Jul 2012 16:24:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120704152451.GA7333@sirena.org.uk>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF45DDF.9000306@nvidia.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 12:14:39AM +0900, Alex Courbot wrote:
> On Wed 04 Jul 2012 10:00:56 PM JST, Sascha Hauer wrote:

> >Also please be aware that using a regulator in the pwm backlight will
> >instantly break all existing users. That's hardly your fault though.

> Sorry, I don't see why. Could you elaborate on this?

All existing machines will start failing during probe as they won't be
able to find the regulator - you should ideally make sure everyone in
mainline gets an appropriate regulator set up.
