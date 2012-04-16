Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2DPOs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:48:29 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35349 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806Ab2DPOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:48:28 -0400
Message-ID: <1334587677.5214.2.camel@odin>
Subject: Re: [PATCH 1/8] regulator: core: Allow drivers to pass in a regmap
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Date: Mon, 16 Apr 2012 15:47:57 +0100
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 12:49 +0100, Mark Brown wrote:
> Since many regulators use regmap for register I/O and since there's quite
> a few very common patterns in the code allow drivers to pass in a regmap
> to the core for use in generic code.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c         |    2 ++
>  include/linux/regulator/driver.h |    4 ++++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 

All 

Acked-by: Liam Girdwood <lrg@ti.com>

