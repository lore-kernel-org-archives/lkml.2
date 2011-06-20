Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1FTKb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:31:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58354 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206Ab1FTKb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:31:27 -0400
Date: Mon, 20 Jun 2011 11:31:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: myungjoo.ham@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 1/2] Exynos4 NURI: configure regulators and PMIC
Message-ID: <20110620103124.GD31864@opensource.wolfsonmicro.com>
References: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
 <20110618151227.GB25163@sirena.org.uk>
 <BANLkTin6hSaNSDd+dEZdkk3F5O5nDYf9yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin6hSaNSDd+dEZdkk3F5O5nDYf9yQ@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 04:58:09PM +0900, MyungJoo Ham wrote:

> However, the MAX8997 driver uses platform_data's entry (variables
> defined in "static struct max8997_platform_data __initdata
> nuri_max8997_pdata)
> in its normal functions other than its probe function, which are often
> called after boot.

That's bad practice on its part.

> I just can't sure whether I should let probe function copy
> platform-data used by non-probe functions to its own local data

This is the best fix.
