Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1JLWvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:51:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46124 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1JLWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:51:47 -0400
Date: Wed, 12 Oct 2011 15:51:53 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm/tegra: Harmony: Configure PMC for low-level
 interrupts
Message-ID: <20111012225153.GA25664@quad.lixom.net>
References: <1316643040-7998-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316643040-7998-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 04:10:40PM -0600, Stephen Warren wrote:
> Without this, the PMC continually detects an interrupt when the PMU_IRQ
> line is high, causing the tps6686x IRQ handler thread to hog an entire
> CPU.
> 
> This change was originally written by Wei Ni <wni@nvidia.com> for Seaboard
> in the ChromeOS kernel.
> 
> Long-term, this should probably be moved into some kind of PMU driver,
> or perhaps integrated into the GPIO/IRQ/pinmux system?
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied to for-3.2/features.


-Olof

