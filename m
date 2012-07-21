Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab2GUPKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 11:10:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62190 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2GUPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 11:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120720100959.GS4495@opensource.wolfsonmicro.com>
References: <1342720012-3709-1-git-send-email-shubhrajyoti@ti.com>
	<20120720100959.GS4495@opensource.wolfsonmicro.com>
Date: Sat, 21 Jul 2012 20:40:42 +0530
Message-ID: <CAM=Q2cs5G5g2LzHbC+dU4GSUrjG49Sc50xpHWNNVkfxPi9Ki2g@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the below warning
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 3:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 19, 2012 at 11:16:52PM +0530, Shubhrajyoti D wrote:
>> The dma_map and dma_unmap should have same parameter
>> passed otherwise we get the below warn.
>
> Applied, thanks.
thanks,
