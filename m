Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab1KHPgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:36:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045Ab1KHPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:36:00 -0500
Date: Tue, 8 Nov 2011 15:35:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jhbird.choi@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Use regmap_read/write(), regmap_update_bits
 functions directly
Message-ID: <20111108153557.GC5632@opensource.wolfsonmicro.com>
References: <1320621364-25711-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320621364-25711-1-git-send-email-jhbird.choi@samsung.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 08:16:04AM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Current driver had the regmapcalls within the bodies of the driver specific read/write fuctions.
> This patch removes the original read/write functions and makes the call sites use regmap directly.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
