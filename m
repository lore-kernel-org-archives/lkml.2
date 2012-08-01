Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2HAUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:06:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39304 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2HAUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:06:48 -0400
Date: Wed, 1 Aug 2012 21:06:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, swarren@wwwdotorg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
Message-ID: <20120801200646.GR4483@opensource.wolfsonmicro.com>
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 01:48:00PM +0530, Laxman Dewangan wrote:
> As per datasheet, the vin pin for the regulator is named
> as vin_sm0, vin_sm1, vin_sm2 for sm0, sm1 and sm2 respectively.

Applied, thanks.
