Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1L1RYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:24:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812Ab1L1RYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:24:34 -0500
Date: Wed, 28 Dec 2011 17:24:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: Add S5M8767 regulator driver
Message-ID: <20111228172431.GE26400@opensource.wolfsonmicro.com>
References: <1324971386-4447-1-git-send-email-sbkim73@samsung.com>
 <1324971386-4447-2-git-send-email-sbkim73@samsung.com>
 <05a301ccc4f4$fda97fb0$f8fc7f10$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05a301ccc4f4$fda97fb0$f8fc7f10$@com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 09:09:39AM +0900, Sangbeom Kim wrote:

> Changes since v2:
> As Mark Brown comments
> - Implement get_voltage_sel
> - Implement set_voltage_time_sel
> - Replace kzalloc with devm_kzalloc
> - Fix indentation error
> - minor changes...

Looks like at least the first two of these got lost somewhere - perhaps
an old version got resent by mistake?
