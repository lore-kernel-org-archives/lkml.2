Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2JQMdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:33:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59678 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2JQMdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:33:32 -0400
Subject: Re: [PATCH] regmap: default Y if REGMAP_MMIO is selected
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <20121017123226.GM14199@opensource.wolfsonmicro.com>
References: <1350477076-27875-1-git-send-email-p.zabel@pengutronix.de>
	 <20121017123226.GM14199@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 14:33:31 +0200
Message-ID: <1350477211.2603.49.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 17.10.2012, 21:32 +0900 schrieb Mark Brown:
> On Wed, Oct 17, 2012 at 02:31:16PM +0200, Philipp Zabel wrote:
> > The syscon mfd driver selects REGMAP_MMIO and uses struct regmap_config,
> > which is only defined if CONFIG_REGMAP is enabled.
> 
> Already fixed by someone else, can't remember who now.  Will send to
> Linus soon.

Great, thanks.

regrads
Philipp

