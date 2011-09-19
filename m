Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1ISDfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:35:45 -0400
Received: from ozlabs.org ([203.10.76.45]:56704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1ISDfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:35:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-net: Read MAC only after initializing MSI-X
In-Reply-To: <20110820200043.GB5276@redhat.com>
References: <1313225461-24458-1-git-send-email-levinsasha928@gmail.com> <20110819152335.GA19489@redhat.com> <1313771587.12243.16.camel@lappy> <20110820200043.GB5276@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 19 Sep 2011 13:05:17 +0930
Message-ID: <871uvdryq2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011 23:00:44 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Aug 19, 2011 at 07:33:07PM +0300, Sasha Levin wrote:
> > Maybe this is better solved by copying the way it was done in PCI itself
> > with capability linked list?
> 
> There are any number of ways to lay out the structure.  I went for what
> seemed a simplest one.  For MSI-X the train has left the station.  We
> can probably still tweak where the high 32 bit features
> for 64 bit features are.  No idea if it's worth it.

Sorry, this has been in the back of my mind.  I think it's a good idea;
can we use the capability linked list for pre-device specific stuff from
now on?

Thanks,
Rusty.
