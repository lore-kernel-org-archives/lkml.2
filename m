Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1KDOE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:04:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41543 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab1KDOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:04:24 -0400
Date: Fri, 4 Nov 2011 14:04:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Message-ID: <20111104140422.GA28615@opensource.wolfsonmicro.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320410928-20349-1-git-send-email-afzal@ti.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 06:18:48PM +0530, Afzal Mohammed wrote:

>  		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
>  			pmic->desc[i].ops = &tps65910_ops_dcdc;
> +			pmic->desc[i].n_voltages = VDD1_2_NUM_VOLTS * 3;

This looks suspicous - what's the * 3 about?
