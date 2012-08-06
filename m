Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2HFOaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:30:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49021 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493Ab2HFOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:30:18 -0400
Date: Mon, 6 Aug 2012 15:30:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: sameo@linux.intel.com, rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806143016.GK16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 12:32:48AM +0800, Haojian Zhuang wrote:

> Since IORESOURCE_IO is used for PCI devices, it doesn't fit on
> 88PM860x PMIC device that lies on I2C bus. So use IORESOURCE_MEM
> instead.

This isn't much more appropriate - _MEM is for memory ranges so isn't
directly relevant to register addresses either.  If anything _IO is
slightly nearer.
