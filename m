Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0FRAbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 20:31:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35511 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752976Ab0FRAbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 20:31:06 -0400
Date: Fri, 18 Jun 2010 01:31:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100618003116.GA2761@opensource.wolfsonmicro.com>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
 <20100616143041.GC24491@rakim.wolfsonmicro.main>
 <000601cb0e21$fa1179b0$ee346d10$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cb0e21$fa1179b0$ee346d10$%szyprowski@samsung.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 03:35:35PM +0200, Marek Szyprowski wrote:

> I've just noticed one more thing. Shouldn't the max8998-pmic driver depend
> on max8998 mfd driver in Kconfig? Or maybe it would be better to select mfd
> driver from the regulators Kconfig? What do you think? 

A dependency is what everything else is using.
