Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1G2MeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:34:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47346 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1G2MeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:34:22 -0400
Date: Fri, 29 Jul 2011 13:34:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: tps65023: Added support for the
 similiar TPS65020 chip
Message-ID: <20110729123420.GB22042@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
 <1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:32:47PM +0200, Marcus Folkesson wrote:

> +static struct tps_driver_data tps65020_drv_data = {
> +		.info = (struct tps_info *) tps65020_regs,

Why do you need the cast here?  I see it's in the original driver too
but it looks like something that should be fixed.
