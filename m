Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2AOL22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 06:28:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36747 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab2AOL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 06:28:27 -0500
Date: Sun, 15 Jan 2012 03:28:03 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Add S5M8767 configuration
Message-ID: <20120115112802.GC3040@opensource.wolfsonmicro.com>
References: <1326417193-13509-1-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326417193-13509-1-git-send-email-sbkim73@samsung.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:13:13AM +0900, Sangbeom Kim wrote:
> This patch add Samsung S5M8767A pmic configuration.
> 
> Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
> ---
> MFD_S5M_CORE is merged with for-next branch on Samuel's MFD tree

Applied, thanks.  There was no need to wait before sending the Kconfig
patch, a missing dependency shouldn't cause any real issues.
