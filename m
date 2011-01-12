Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab1ALGCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:02:49 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52285 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab1ALGCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:02:47 -0500
Date: Wed, 12 Jan 2011 15:00:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/16] nuc900fb: don't treat NULL clk as an error
Message-ID: <20110112060040.GC2350@linux-sh.org>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-7-git-send-email-jamie@jamieiles.com> <AANLkTingg+wm8jy4kRL=ubLFrCDXq17jZQkD3v3M4h+Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTingg+wm8jy4kRL=ubLFrCDXq17jZQkD3v3M4h+Y@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 09:24:47AM +0800, Wan ZongShun wrote:
> 2011/1/11 Jamie Iles <jamie@jamieiles.com>:
> > clk_get() returns a struct clk cookie to the driver and some platforms
> > may return NULL if they only support a single clock. ??clk_get() has only
> > failed if it returns a ERR_PTR() encoded pointer.
> >
> > Cc: Wan ZongShun <mcuos.com@gmail.com>
> > Cc: linux-fbdev@vger.kernel.org
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> 
> Thanks for your patch.
> 
> Acked-by: Wan ZongShun <mcuos.com@gmail.com>
> 
Applied, thanks.
