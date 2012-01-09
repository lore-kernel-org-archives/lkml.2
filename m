Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2AIHZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:25:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41001 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab2AIHZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:25:38 -0500
Date: Sun, 8 Jan 2012 23:25:15 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: Add S5M8767A regulator driver
Message-ID: <20120109072515.GE22134@opensource.wolfsonmicro.com>
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 03:05:53PM +0900, Sangbeom Kim wrote:

Ah, I knew there was a reason why I hadn't reviewed this!  I was
expecting a new version with these:

> +static int s5m8767_reg_enable_suspend(struct regulator_dev *rdev)
> +static int s5m8767_reg_disable_suspend(struct regulator_dev *rdev)

removed.  Otherwise this looks good.
