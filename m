Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2CZEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:25:26 -0400
Received: from ozlabs.org ([203.10.76.45]:34474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2CZEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:24:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [RFC V2 PATCH] virtio-spec: ack the announce notification through ctrl_vq
In-Reply-To: <20120323030501.6912.96218.stgit@jason-ThinkPad-T400>
References: <20120323030501.6912.96218.stgit@jason-ThinkPad-T400>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 26 Mar 2012 11:12:05 +1030
Message-ID: <878viochwi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 11:05:01 +0800, Jason Wang <jasowang@redhat.com> wrote:
> During link announcement, driver needs a method to notify device that it has
> received the notification and let it clear the VIRITO_NET_S_ANNOUNCE bit in the
> status field. Doing this through a dedicated command looks suitable for all
> platforms (especially for the ones who don't trap the status read or write) with
> a ctrl vq and can solve the race between host and guest.
> 
> So this patch makes VIRTIO_NET_F_ANNOUNCE depends on VIRTIO_NET_F_CTRL_VQ and
> introduces a dedicated command VIRTIO_NET_CTRL_ANNOUNCE_ACK to let device clear
> the VIRTIO_NET_S_ANNOUNCE bit in the status field.

Applied, thanks!

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
