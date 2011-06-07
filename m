Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1FGSpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:45:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46733 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1FGSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110607171403.GA3011@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi> <4b27fc93b7df900943e7c12084a8340cbc5fe1a8.1306662317.git.mika.westerberg@iki.fi>
 <20110603204400.GH17972@ponder.secretlab.ca> <20110607171403.GA3011@acer>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 7 Jun 2011 12:45:26 -0600
X-Google-Sender-Auth: Mldaukkt04rsFIpXAVzm-jt2qtA
Message-ID: <BANLkTikKOcc2Vg1p3kG4ZSLjJ0RTZWS=2A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] spi/ep93xx: add DMA support
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        rmallon@gmail.com, vinod.koul@intel.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 11:14 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
> On Fri, Jun 03, 2011 at 02:44:00PM -0600, Grant Likely wrote:
>> On Sun, May 29, 2011 at 01:10:06PM +0300, Mika Westerberg wrote:
>> > This patch adds DMA support for the EP93xx SPI driver. By default the DMA is
>> > not enabled but it can be enabled by setting ep93xx_spi_info.use_dma to true
>> > in board configuration file.
>> >
>> > Note that the SPI driver still uses PIO for small transfers (<= 8 bytes) for
>> > performance reasons.
>> >
>> > Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
>> > Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Since this depends on the DMA patches, it can go in via the same tree.
>
> I just realized that once the SPI driver renaming patch (spi: reorganize
> drivers) enters linux-next, this patch (which sits on Vinod's tree) will cause
> a merge conflict. Any ideas how to avoid it beforehand?

Yes, put the whole series into a separate branch all by itself.  Merge
that branch into Vinod's tree and I'll also merge it into spi/next,
and I'll fix up the merge conflict when I do.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
