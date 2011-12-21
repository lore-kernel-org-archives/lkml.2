Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1LUBVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:21:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1LUBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:21:19 -0500
Date: Wed, 21 Dec 2011 01:21:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GPIO: add bindings for managed devices
Message-ID: <20111221012117.GD13529@sirena.org.uk>
References: <1324413621-11630-1-git-send-email-blogic@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324413621-11630-1-git-send-email-blogic@openwrt.org>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 09:40:21PM +0100, John Crispin wrote:

> +/**
> + *      devm_gpio_request - request a gpio for a managed device
> + *      @dev: device to request the gpio for
> + *      @gpio: gpio to allocate
> + *      @label: the name of the requested gpio

It'd be nicer to wrap gpio_request_one() as that's a bit neater from the
driver point of view since it combines the request with the mandatory
configuration step to put the GPIO into the appropraite mode.
