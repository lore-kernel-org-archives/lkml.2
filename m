Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2KFKJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:09:54 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:32920 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2KFKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:09:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121106092224.GL5044@opensource.wolfsonmicro.com>
References: <1352193447-23335-1-git-send-email-shubhrajyoti@ti.com>
	<20121106092224.GL5044@opensource.wolfsonmicro.com>
Date: Tue, 6 Nov 2012 15:39:50 +0530
Message-ID: <CAM=Q2csWBNbEDPevQ0Wy6CJjL928PN9HwvEZV=FkM5TBux05xQ@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2-mcspi: Reorder the wait_for_completion for tx
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 2:52 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 06, 2012 at 02:47:27PM +0530, Shubhrajyoti D wrote:
>> The commit  d7b4394e[Cleanup the omap2_mcspi_txrx_dma function]
>> changed the wait_for_completion order. Move the wait so that the
>> rx doesnot wait for the tx to complete.
>
> Is this a resend of the patch I just applied, or is it something
> different?

No please ignore this one.

Something wrong at my end it got sent twice.
Please ignore.
