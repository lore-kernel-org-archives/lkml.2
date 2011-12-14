Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1LNROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:14:51 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41491 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab1LNROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:14:49 -0500
X-Sasl-enc: S4bNscqdXVJQstIawf0vGg9XUCyPj2FphHzyJ7pC/9Tn 1323882888
Date: Wed, 14 Dec 2011 09:14:41 -0800
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        security@kernel.org, Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] drm: integer overflow in drm_mode_dirtyfb_ioctl()
Message-ID: <20111214171441.GA7172@kroah.com>
References: <CAGyNYUNwMs0ntak4bo5S1EMuEoTuTwsV1dKAc1gu8qF9qQ4ZLg@mail.gmail.com>
 <2486420a-edef-443a-ba5e-18fb5efb0eb9@zmail16.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2486420a-edef-443a-ba5e-18fb5efb0eb9@zmail16.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:34:29AM -0500, David Airlie wrote:
> 
> ----- Original Message -----
> > From: "Eugene Teo" <eugeneteo@kernel.sg>
> > To: "Xi Wang" <xi.wang@gmail.com>
> > Cc: "David Airlie" <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
> > security@kernel.org, "Dave Airlie" <airlied@redhat.com>
> > Sent: Wednesday, 14 December, 2011 1:16:49 PM
> > Subject: Re: [PATCH] drm: integer overflow in drm_mode_dirtyfb_ioctl()
> > 
> > Cc'ed Dave's work email.
> 
> This is already in Linus tree, went there a while ago.
> 
> a5cd335165e31db9dbab636fd29895d41da55dd2

And it was in the 3.0.13 and 3.1.5 kernel releases.

greg k-h
