Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1EIJ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:56:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736Ab1EIJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:56:21 -0400
Date: Mon, 9 May 2011 11:56:28 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Use mc13xxx_reg_write instead of
 mc13xxx_reg_rmw in mc13892_sw_regulator_set_voltage
Message-ID: <20110509095628.GD22899@opensource.wolfsonmicro.com>
References: <1304934580.9600.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304934580.9600.7.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 05:49:40PM +0800, Axel Lin wrote:
> Currently, we call mc13xxx_reg_read and mc13xxx_reg_rmw for the same register.
> This can be converted to simply a mc13xxx_reg_read and a mc13xxx_reg_write,
> thus save a redundant register read.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
