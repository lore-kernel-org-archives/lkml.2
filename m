Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1AQAd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:33:56 -0500
Received: from ozlabs.org ([203.10.76.45]:57364 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1AQAdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:33:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio: remove virtio-pci root device
Date: Mon, 17 Jan 2011 11:03:51 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: Gleb Natapov <gleb@redhat.com>, Milton Miller <miltonm@bga.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20110105191711.GA27489@redhat.com> <20110110171046.GB27292@redhat.com> <20110110171904.GA30058@redhat.com>
In-Reply-To: <20110110171904.GA30058@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101171103.51778.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 03:49:04 am Michael S. Tsirkin wrote:
> On Mon, Jan 10, 2011 at 07:10:46PM +0200, Gleb Natapov wrote:
> > On Fri, Jan 07, 2011 at 02:55:06AM -0600, Milton Miller wrote:
> > > We sometimes need to map between the virtio device and
> > > the given pci device. One such use is OS installer that
> > > gets the boot pci device from BIOS and needs to
> > > find the relevant block device. Since it can't,
> > > installation fails.
> > > 
> > > Instead of creating a top-level devices/virtio-pci
> > > directory, create each device under the corresponding
> > > pci device node.  Symlinks to all virtio-pci
> > > devices can be found under the pci driver link in
> > > bus/pci/drivers/virtio-pci/devices, and all virtio
> > > devices under drivers/bus/virtio/devices.
> > > 
> > > Signed-off-by: Milton Miller <miltonm@bga.com>
> > Acked-by: Gleb Natapov <gleb@redhat.com>
> 
> Rusty, any comments?
> We are going to tell the installer guys that this
> is the interface, would be nice to know that the
> patch is queued before we do.

Yep, I've applied it.  Sorry, took a week off to work on my linux.conf.au
talk...

Cheers,
Rusty.
