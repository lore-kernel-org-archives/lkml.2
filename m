Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2AIGr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:47:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50013 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296Ab2AIGr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:47:27 -0500
Date: Sun, 8 Jan 2012 22:47:04 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: Add S5M8767A regulator driver
Message-ID: <20120109064703.GT29065@opensource.wolfsonmicro.com>
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
 <20120108231657.GD13679@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120108231657.GD13679@sortiz-mobl>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:16:57AM +0100, Samuel Ortiz wrote:

> Mark, are you ok with this one ? As it depends on the previous MFD patches,
> I'll have to take it through the MFD tree.

I've not reviwed it yet and there should be no dependency on the MFD
tree so no need to merge it via that - the fact that there's a Kconfig
dependency on the MFD means that the two can get merged in any order.
