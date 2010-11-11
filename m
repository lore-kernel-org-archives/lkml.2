Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab0KKApN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:45:13 -0500
Received: from ozlabs.org ([203.10.76.45]:51545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354Ab0KKApM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:45:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RESEND PATCH] virtio-net: init link state correctly
Date: Thu, 11 Nov 2010 11:15:05 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, markmc@redhat.com,
        kvm@vger.kernel.org
References: <20101105094718.19101.58898.stgit@dhcp-91-158.nay.redhat.com> <201011080941.28190.rusty@rustcorp.com.au> <20101110150823.GA5622@redhat.com>
In-Reply-To: <20101110150823.GA5622@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111115.06161.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 01:38:23 am Michael S. Tsirkin wrote:
> On Mon, Nov 08, 2010 at 09:41:27AM +1030, Rusty Russell wrote:
> > On Fri, 5 Nov 2010 08:17:18 pm Jason Wang wrote:
> > > For device that supports VIRTIO_NET_F_STATUS, there's no need to
> > > assume the link is up and we need to call nerif_carrier_off() before
> > > querying device status, otherwise we may get wrong operstate after
> > > diver was loaded because the link watch event was not fired as
> > > expected.
> > > 
> > > For device that does not support VIRITO_NET_F_STATUS, we could not get
> > > its status through virtnet_update_status() and what we can only do is
> > > always assuming the link is up.
> > > 
> > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > Thanks!
> > Rusty.
> 
> Rusty, just to verify: who shall be queueing this up?

Sorry, that was sloppy of me; was meant for DaveM to take.

Sending explicitly now...
Rusty.
