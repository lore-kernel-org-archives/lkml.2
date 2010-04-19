Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0DSRA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:00:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55493 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753589Ab0DSRAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:00:55 -0400
Date: Tue, 20 Apr 2010 02:01:00 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mc13783-regulator: fix a memory leak in
 mc13783_regulator_remove
Message-ID: <20100419170059.GB29819@opensource.wolfsonmicro.com>
References: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 09:58:02AM +0800, Axel Lin wrote:
> This patch fixes a memory leak by freeing priv in mc13783_regulator_remove

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but note that...

> +       platform_set_drvdata(pdev, NULL);
> +

This is completely unrelated to what your description says (and is not
needed).
