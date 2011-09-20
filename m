Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1ITJuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:50:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43424 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755792Ab1ITJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:50:22 -0400
Date: Tue, 20 Sep 2011 10:50:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, lrg@ti.com
Subject: Re: [PATCH] tps65023-regulator: remove duplicate REG_CTRL2 defines
Message-ID: <20110920095020.GA2387@opensource.wolfsonmicro.com>
References: <201109191851.40743.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109191851.40743.hartleys@visionengravers.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:51:39PM -0700, H Hartley Sweeten wrote:
> There are two sets of defines for the REG_CTRL2 bitfields and one
> of them has TPS65023_REG_CTRL2_DCDC1 defined incorrectly. Remove
> the duplicates and leave the correct one for TPS65023_REG_CTRL2_DCDC1.
> 
> This fixes the following sparse warnings:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
