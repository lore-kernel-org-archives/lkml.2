Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2AOMQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:16:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36204 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab2AOMQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:16:28 -0500
Date: Sun, 15 Jan 2012 12:16:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH V4 2/2] regulator: tps65217: Add tps65217 regulator driver
Message-ID: <20120115121616.GE3040@opensource.wolfsonmicro.com>
References: <1326278509-31310-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326278509-31310-1-git-send-email-anilkumar@ti.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 04:11:49PM +0530, AnilKumar Ch wrote:
> This patch adds tps65217 PMIC as a regulator
> 
> The regulator module consists of 3 DCDCs and 4 LDOs. The output
> voltages are configurable and are meant to supply power to the
> main processor and other components

Looks good, applied thanks.
