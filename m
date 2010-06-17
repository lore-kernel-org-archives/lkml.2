Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab0FQNgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:36:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024Ab0FQNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:36:41 -0400
Date: Thu, 17 Jun 2010 15:35:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v3] drivers: regulator: add Maxim 8998 driver
In-reply-to: <20100616143041.GC24491@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Message-id: <000601cb0e21$fa1179b0$ee346d10$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsNYIPVv8mjLnNkTa6PrGJi4PYnKQAwRxGg
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
 <20100616143041.GC24491@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, June 16, 2010 4:31 PM Mark Brown wrote:

> On Wed, Jun 16, 2010 at 09:04:16AM +0200, Marek Szyprowski wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> > is used on Samsung Aquila and GONI boards and provides following
> > functionalities:
> > - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
> >   controllers
> > - battery charger
> >
> > This patch adds basic driver for voltage regulators and MAX 8998 MFD core.
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Looks good!
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I've just noticed one more thing. Shouldn't the max8998-pmic driver depend
on max8998 mfd driver in Kconfig? Or maybe it would be better to select mfd
driver from the regulators Kconfig? What do you think? 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


