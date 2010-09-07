Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0IGMx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:53:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46367 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0IGMxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:53:47 -0400
Date: Tue, 7 Sep 2010 13:53:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vapier@gentoo.org, khilman@deeprootsystems.com,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20100907125335.GD25830@sirena.org.uk>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com> <4C862EB3.4080006@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C862EB3.4080006@compulab.co.il>
X-Cookie: Truckers welcome.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 03:23:15PM +0300, Igor Grinberg wrote:
>  Seems that there are some more platforms then Sharp Zaurus
> are interested in this patch.
> 
> Dmitry, Mike, Pavel,
> 
> What's the status of it?

>From a regulator API usage point of view a separate implementation of
the same thing was nacked - there are regulator API facilties for hiding
missing regulators from drivers when needed to get systems going, unless
the device genuinely can cope without supplies it should be relying on
those.
