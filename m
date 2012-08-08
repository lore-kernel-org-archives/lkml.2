Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2HHNcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:32:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51670 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758359Ab2HHNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:32:05 -0400
Date: Wed, 8 Aug 2012 14:32:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Liam Girdwood <lrg@ti.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: make the dummy regulator's
 print_constraint more helpful
Message-ID: <20120808133202.GA16861@opensource.wolfsonmicro.com>
References: <20120807181642.GF16861@opensource.wolfsonmicro.com>
 <1344366097-23775-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344366097-23775-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 09:01:37PM +0200, Uwe Kleine-König wrote:
> This prevents the output of just
> 
> 	dummy:
> 
> in the boot log. Now it says:
> 
> 	regulator-dummy: no parameters

Applied, thanks.
