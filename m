Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1JWImh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:42:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46687 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab1JWImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:42:36 -0400
Date: Sun, 23 Oct 2011 09:42:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: Add s5m series irq support
Message-ID: <20111023084233.GB3135@opensource.wolfsonmicro.com>
References: <009301cc915a$cd72d1c0$68587540$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009301cc915a$cd72d1c0$68587540$@com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 05:07:26PM +0900, Sangbeom Kim wrote:
> This patch support irq for s5m series.
> Basically, S5M8767 and S5M8763 irq can be handled by this patch.

This all looks pretty good, though it looks somewhat familiar :)

Actually, one of the things I want to do in the 3.3 timeframe is to
factor out this code from my drivers into a regmap based irq_chip since
it seems a lot of people are "drawing inspiration" from it.  This
shouldn't be any form of blocker for merging this driver though.
