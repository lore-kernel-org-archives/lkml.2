Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0GBJc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:32:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42140 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756924Ab0GBJc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:32:57 -0400
Date: Fri, 2 Jul 2010 10:33:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <linux@arm.linux.org.uk>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
Message-ID: <20100702093310.GA19712@opensource.wolfsonmicro.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de>
 <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
 <20100701130724.GC17698@sirena.org.uk>
 <AANLkTim0usB99K6orH0lxP73e-XK69ytdECtR5D1dPJt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim0usB99K6orH0lxP73e-XK69ytdECtR5D1dPJt@mail.gmail.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 04:08:56PM +0900, Jassi Brar wrote:
> On Thu, Jul 1, 2010 at 10:07 PM, Mark Brown

> > Hrm, if this is part of the default hardware build we should get the
> > driver merged.

> But the machine driver is already there
>    sound/soc/s3c24xx/smdk2443_wm9710.c

Oh, right.  I was just assuming that it wasn't there since the symbol
isn't defined in mainline, I hadn't actually looked.
