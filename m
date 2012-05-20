Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab2ETEzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 00:55:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2ETEzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 00:55:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi/omap2-mcspi: convert to the pump message infrastructure
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: spi-devel-general@lists.sourceforge.net,
        Shubhrajyoti D <shubhrajyoti@ti.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CAM=Q2csCk3B=mQH+zifE8y0XfPW=qgjH=Ya9PunaWRHFo+dLfQ@mail.gmail.com>
References: <1336654665-693-1-git-send-email-shubhrajyoti@ti.com> <CACRpkdbb0pRmnN-E_M7MLZoN5c_vYNj4AWsSvv-9ZDJzh3Pbjw@mail.gmail.com> <CAM=Q2csCk3B=mQH+zifE8y0XfPW=qgjH=Ya9PunaWRHFo+dLfQ@mail.gmail.com>
Date: Sat, 19 May 2012 22:55:14 -0600
Message-Id: <20120520045514.AD9BB3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 12:04:15 +0530, Shubhrajyoti Datta <omaplinuxkernel@gmail.com> wrote:
> Hi Linus,
> 
> On Tue, May 15, 2012 at 1:42 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, May 10, 2012 at 2:57 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> >
> >> This patch converts the OMAP SPI driver to use the SPI infrastructure
> >> pump message queue.Also fixes the below warning.
> >> master is unqueued, this is deprecated
> >>
> >> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> >
> > Final version of the patch?
> Lest someone has comments.
> 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

