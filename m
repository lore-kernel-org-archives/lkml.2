Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2JIG2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:28:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43919 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2JIG2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:28:51 -0400
Date: Tue, 9 Oct 2012 15:28:43 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, vbyravarasu@nvidia.com,
        axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
Message-ID: <20121009062841.GL8237@opensource.wolfsonmicro.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-7-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349536671-31714-7-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 08:47:51PM +0530, Laxman Dewangan wrote:
> The TPS65090's DCDC outut can also be enable/disable through the
> external digital input signal. Add support for enable/disable
> either through register access via I2C or through external
> control inputs. The external control inputs can be driven through
> GPIOs also and hence adding support for passing the GPIO number.

There's support for GPIO driven enable lines in the framework already,
this driver should be able to use this happily, this sort of hardware is
exactly the use case it was written for.
