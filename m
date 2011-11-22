Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1KVRcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:32:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47509 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1KVRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:32:33 -0500
Date: Tue, 22 Nov 2011 17:32:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: w.sang@pengutronix.de, Wim@vger.kernel.org, wim@iguana.be,
        Welte@vger.kernel.org, Van@vger.kernel.org, Sebroeck@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Harald@vger.kernel.org
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111122173227.GK6624@sirena.org.uk>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
X-Cookie: "Elvis is my copilot."
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 06:05:48PM +0100, Marc Vertes wrote:

> +static int wdt_start(struct watchdog_device *wdev)
> +{
> +	/* Nothing to do. The watchdog can only be started by the BIOS. */
> +	return 0;
> +}

Shouldn't we just update the framework to cope with missing functions?
