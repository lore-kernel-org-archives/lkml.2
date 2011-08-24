Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1HXQ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:26:23 -0400
Received: from eazy.amigager.de ([213.239.192.238]:42726 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1HXQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:26:19 -0400
Date: Wed, 24 Aug 2011 18:26:18 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Florian Mickler <florian@mickler.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "v3.0.y" <stable@kernel.org>
Subject: Re: [PATCH] [media] vp7045: fix buffer setup
Message-ID: <20110824162618.GA26016@mac.home>
Mail-Followup-To: Florian Mickler <florian@mickler.org>,
	mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, "v3.0.y" <stable@kernel.org>
References: <20110809200842.GA29662@mac.home>
 <1312970720-25694-1-git-send-email-florian@mickler.org>
 <20110819183521.1b5f7efe@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819183521.1b5f7efe@schatten.dmk.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 18:35:21 +0200, Florian Mickler wrote:
> On Wed, 10 Aug 2011 12:05:20 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > dvb_usb_device_init calls the frontend_attach method of this driver which
> > uses vp7045_usb_ob. In order to have a buffer ready in vp7045_usb_op, it has to
> > be allocated before that happens.
> > 
> > Luckily we can use the whole private data as the buffer as it gets separately
> > allocated on the heap via kzalloc in dvb_usb_device_init and is thus apt for
> > use via usb_control_msg.
> > 
> > This fixes a
> > 	BUG: unable to handle kernel paging request at 0000000000001e78
> > 
> > reported by Tino Keitel and diagnosed by Dan Carpenter.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=40062
> > Cc: v3.0.y <stable@kernel.org>
> > Tested-by: Tino Keitel <tino.keitel@tikei.de>
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> 
> ...ping...

Even pinger. I can't see the patch in 3.1 git yet, and I'm using the
patch on 3.0 kernels for 2 weeks now without problems.

Regards,
Tino
