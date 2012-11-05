Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2KEOfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:35:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40566 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2KEOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:35:47 -0500
Date: Mon, 5 Nov 2012 15:35:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-mmio: Fix irq parsing in command line parameter
Message-ID: <20121105143541.GD5220@gmail.com>
References: <1352120454.10947.5.camel@hornet>
 <1352120572-16256-1-git-send-email-pawel.moll@arm.com>
 <20121105134413.GC5220@gmail.com>
 <1352124778.10947.8.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352124778.10947.8.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012, Pawel Moll wrote:

> On Mon, 2012-11-05 at 13:44 +0000, Lee Jones wrote:
> > On Mon, 05 Nov 2012, Pawel Moll wrote:
> > 
> > > On 64-bit machines resource_size_t is a 64-bit value, while
> > > sscanf() format for this argument was defined as "%u". Fixed
> > > by using an intermediate local value of a known length.
> > > 
> > > Also added cleaned up the resource creation and adde extra
> > > comments to make the parameters parsing easier to follow.
> > > 
> > > Reported-by: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > > ---
> > >  drivers/virtio/virtio_mmio.c |   26 ++++++++++++++++++--------
> > >  1 file changed, 18 insertions(+), 8 deletions(-)
> > 
> > Resorted to poaching now have we Pawel? ;)
> 
> Sure thing - the poached eggs are my firm favourite :-P ;-)
> 
> But seriously speaking - it's an old patch (all the comments and
> resources creation, the IRQ stuff is a new thing :-), but never had
> enough motivation to push it out...

I believe you, many would not. ;)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
