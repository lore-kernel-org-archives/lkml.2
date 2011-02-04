Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1BDCkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 21:40:10 -0500
Received: from ozlabs.org ([203.10.76.45]:52769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1BDCkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 21:40:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] virtio_blk: allow re-reading config space at runtime
Date: Fri, 4 Feb 2011 13:09:59 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <20110114160137.GA18721@lst.de> <20110201195136.GA26688@redhat.com> <20110201204348.GA22119@lst.de>
In-Reply-To: <20110201204348.GA22119@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041310.00122.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011 07:13:48 am Christoph Hellwig wrote:
> Wire up the virtio_driver config_changed method to get notified about
> config changes raised by the host.  For now we just re-read the device
> size to support online resizing of devices, but once we add more
> attributes that might be changeable they could be added as well.
> 
> Note that the config_changed method is called from irq context, so
> we'll have to use the workqueue infrastructure to provide us a proper
> user context for our changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, applied!

Cheers,
Rusty.
