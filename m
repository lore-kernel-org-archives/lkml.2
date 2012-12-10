Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2LJDYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:24:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32914 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab2LJDYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:24:18 -0500
Date: Mon, 10 Dec 2012 12:24:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RFT v2] regulator: max1586: Implement get_voltage_sel
 callback
Message-ID: <20121210032411.GF10927@opensource.wolfsonmicro.com>
References: <1354166383.17552.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354166383.17552.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:19:43PM +0800, Axel Lin wrote:
> This is required since commit f7df20ec32
> "regulator: core: Use list_voltage() to read single voltage regulators",
> otherwise _regulator_get_voltage returns rdev->desc->ops->list_voltage(rdev, 0).

Applied, thanks.
