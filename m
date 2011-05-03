Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1ECR2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:28:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39311 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753399Ab1ECR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:28:19 -0400
Date: Tue, 3 May 2011 18:28:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCH 5/5] TPS65911: Comparator: Add comparator driver
Message-ID: <20110503172817.GD1762@opensource.wolfsonmicro.com>
References: <2F3D4669-91BC-400F-8A0F-D854DBB9C756@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2F3D4669-91BC-400F-8A0F-D854DBB9C756@slimlogic.co.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:19:07AM -0500, Jorge Eduardo Candelaria wrote:

> +/* Comparator 1 voltage selection table in milivolts */
> +static const u16 COMP1_VSEL_TABLE[] = {
> +	0, 2500, 2500, 2500, 2500, 2550, 2600, 2650,
> +	2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050,
> +	3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450,
> +	3500,
> +};
> +
> +/* Comparator 2 voltage selection table in milivolts */
> +static const u16 COMP2_VSEL_TABLE[] = {
> +	0, 2500, 2500, 2500, 2500, 2550, 2600, 2650,
> +	2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050,
> +	3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450,
> +	3500,
> +};

These look remarkably similar...

> +static DEVICE_ATTR(comp1_threshold, S_IRUGO, comp_threshold_show, NULL);
> +static DEVICE_ATTR(comp2_threshold, S_IRUGO, comp_threshold_show, NULL);

We should really have a proper API for this, it's a pretty common
feature on devices with an auxilliary ADC of some kind.
