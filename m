Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1LUAcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:32:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33322 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1LUAcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:32:13 -0500
Date: Wed, 21 Dec 2011 00:32:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: ASoC: missed hx4700-audio platform device for hx4700
Message-ID: <20111221003209.GB13529@sirena.org.uk>
References: <1324114379.28427.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324114379.28427.1.camel@phoenix>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 05:32:59PM +0800, Axel Lin wrote:
> The iPAQ hx4700 machine driver needs a hx4700-audio platform device which is
> not (yet) merged.

> The patchs was post on LKML: https://lkml.org/lkml/2011/5/18/222
> but [PATCH v3 3/3] pxa/hx4700: add platform device and I2C info for AK4641 codec is missed.

You probably want to resend the patch to the PXA maintainers with an
appropriate subject line.
