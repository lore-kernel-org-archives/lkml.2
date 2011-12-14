Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab1LNNjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:39:39 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38267 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1LNNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:39:38 -0500
Date: Wed, 14 Dec 2011 08:34:29 -0500 (EST)
From: David Airlie <airlied@redhat.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] drm: integer overflow in drm_mode_dirtyfb_ioctl()
Message-ID: <2486420a-edef-443a-ba5e-18fb5efb0eb9@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <CAGyNYUNwMs0ntak4bo5S1EMuEoTuTwsV1dKAc1gu8qF9qQ4ZLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.6.35]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
> From: "Eugene Teo" <eugeneteo@kernel.sg>
> To: "Xi Wang" <xi.wang@gmail.com>
> Cc: "David Airlie" <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
> security@kernel.org, "Dave Airlie" <airlied@redhat.com>
> Sent: Wednesday, 14 December, 2011 1:16:49 PM
> Subject: Re: [PATCH] drm: integer overflow in drm_mode_dirtyfb_ioctl()
> 
> Cc'ed Dave's work email.

This is already in Linus tree, went there a while ago.

a5cd335165e31db9dbab636fd29895d41da55dd2

Dave.
