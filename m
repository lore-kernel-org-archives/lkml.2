Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2KFJSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:18:05 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60708 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2KFJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121106090353.GI5044@opensource.wolfsonmicro.com>
References: <1352192419-22872-1-git-send-email-shubhrajyoti@ti.com>
	<20121106090353.GI5044@opensource.wolfsonmicro.com>
Date: Tue, 6 Nov 2012 14:47:57 +0530
Message-ID: <CAM=Q2ctSOEC+6=Mor_aceis5txdE7C-YEp-6NGtwEQ8Tqqvtbg@mail.gmail.com>
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

On Tue, Nov 6, 2012 at 2:33 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 06, 2012 at 02:30:19PM +0530, Shubhrajyoti D wrote:
>> The commit  d7b4394e[Cleanup the omap2_mcspi_txrx_dma function]
>> changed the wait_for_completion order. Move the wait so that the
>> rx doesnot wait for the tx to complete.
>
> Applied, thanks.

Thanks Mark,
