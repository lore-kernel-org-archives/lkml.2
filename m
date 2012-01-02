Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2ABLg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:36:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab2ABLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:36:26 -0500
Date: Mon, 2 Jan 2012 11:36:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: Enable supply regulator if child rail is
 enabled.
Message-ID: <20120102113623.GC2899@opensource.wolfsonmicro.com>
References: <1325489925-5148-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325489925-5148-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 01:08:45PM +0530, Laxman Dewangan wrote:
> During regulator_register, the rail is set on the provided
> machine constraints and if it is enabled then it is also
> require to enable the supply regulator. This will make sure
> that:
>    1. Proper reference count for supply regulator to be maintain.
>    2. Supply regulator should be enable when given rail is enabled.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied, thanks.

> When given rail is registered and if it has machine constratins to
> enable the rail then it is also require to enable the supply rail for
> a given rail. This will make sure that given rail is enabled and
> proper reference count is maintained for the supply rail to avoid
> disable of supply rail even child rail is enabled.

Why is this not in the changelog?
