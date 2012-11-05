Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2KEONG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:13:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52478 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2KEONB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:13:01 -0500
Message-ID: <1352124778.10947.8.camel@hornet>
Subject: Re: [PATCH] virtio-mmio: Fix irq parsing in command line parameter
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Mon, 05 Nov 2012 14:12:58 +0000
In-Reply-To: <20121105134413.GC5220@gmail.com>
References: <1352120454.10947.5.camel@hornet>
	 <1352120572-16256-1-git-send-email-pawel.moll@arm.com>
	 <20121105134413.GC5220@gmail.com>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2012 14:12:58.0635 (UTC) FILETIME=[A87835B0:01CDBB5F]
X-MC-Unique: 112110514125925501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 13:44 +0000, Lee Jones wrote:
> On Mon, 05 Nov 2012, Pawel Moll wrote:
> 
> > On 64-bit machines resource_size_t is a 64-bit value, while
> > sscanf() format for this argument was defined as "%u". Fixed
> > by using an intermediate local value of a known length.
> > 
> > Also added cleaned up the resource creation and adde extra
> > comments to make the parameters parsing easier to follow.
> > 
> > Reported-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> >  drivers/virtio/virtio_mmio.c |   26 ++++++++++++++++++--------
> >  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> Resorted to poaching now have we Pawel? ;)

Sure thing - the poached eggs are my firm favourite :-P ;-)

But seriously speaking - it's an old patch (all the comments and
resources creation, the IRQ stuff is a new thing :-), but never had
enough motivation to push it out...

Cheers!

Paweł



