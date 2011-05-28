Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1E1MNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 08:13:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41792 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1E1MNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 08:13:35 -0400
Date: Sat, 28 May 2011 13:13:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Use device platform_data to retrieve db8500
	platform bits
Message-ID: <20110528121331.GA1041@sirena.org.uk>
References: <20110526090827.GC20259@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526090827.GC20259@sortiz-mobl>
X-Cookie: A rolling stone gathers momentum.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:08:27AM +0200, Samuel Ortiz wrote:
> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please always CC maintainers on patches!
