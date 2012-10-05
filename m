Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2JES6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:58:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53016 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab2JES6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:58:40 -0400
Date: Fri, 5 Oct 2012 19:58:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        arnd@arndb.de, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 5/6] power: da9052-battery: Convert to the new da9052
 interrupt functions
Message-ID: <20121005185838.GH4360@opensource.wolfsonmicro.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
 <1349320509-26930-5-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349320509-26930-5-git-send-email-festevam@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:15:08AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Convert to the new da9052 interrupt functions, so that we can get rid of 
> irq_base references.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
