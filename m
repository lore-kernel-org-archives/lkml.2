Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2KWLPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:15:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:20550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2KWLPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:15:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="246159218"
Date: Fri, 23 Nov 2012 12:15:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 2/2] regulator: add a regulator driver for the AS3711
 PMIC
Message-ID: <20121123111515.GD12685@sortiz-mobl>
References: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
 <Pine.LNX.4.64.1211221110330.28453@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211221110330.28453@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi, Mark,

On Thu, Nov 22, 2012 at 11:12:08AM +0100, Guennadi Liakhovetski wrote:
> This driver supports the 4 DCDC and 8 LDO regulators on the AS3711 PMIC.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2: make platform data optional
> 
>  drivers/regulator/Kconfig            |    7 +
>  drivers/regulator/Makefile           |    1 +
>  drivers/regulator/as3711-regulator.c |  379 ++++++++++++++++++++++++++++++++++
>  3 files changed, 387 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/as3711-regulator.c
Mark, does that look ok with you ? There's a build dependency with patch #1,
so it would make sense for me to take it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
