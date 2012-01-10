Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2AJXb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:31:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374Ab2AJXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:31:28 -0500
Date: Tue, 10 Jan 2012 15:31:17 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] regulator: Add S5M8767A regulator driver
Message-ID: <20120110233115.GA15969@opensource.wolfsonmicro.com>
References: <1326103825-16860-1-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326103825-16860-1-git-send-email-sbkim73@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:10:25PM +0900, Sangbeom Kim wrote:

> S5M8767A is a cost-effective PMIC which is designed for mobile applications.
> It includes high efficient 9 Buck converters, 28 LDOs.
> Especially, S5M8767A is optimized for Multi-core SOCs.
> And during DVFS operation, S5M8767A output stable voltage.
> This patch implement regulator driver for S5M8767A.

Applied, thanks.
