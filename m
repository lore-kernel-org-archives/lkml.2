Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0FURtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:49:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53713 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0FURtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:49:53 -0400
Subject: Re: [PATCH] drivers: regulators: depend on MFD_MAX8998
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
In-Reply-To: <1277107463-28153-1-git-send-email-m.szyprowski@samsung.com>
References: <20100618003116.GA2761@opensource.wolfsonmicro.com>
	 <1277107463-28153-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 18:49:55 +0100
Message-ID: <1277142595.3288.45.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 10:04 +0200, Marek Szyprowski wrote:
> The MAX8998-pmic driver requires a core driver for all io operations. Like
> other regulator driver make it depend of the required MFD io driver.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/regulator/Kconfig |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

