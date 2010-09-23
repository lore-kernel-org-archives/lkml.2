Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0IWIGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:06:14 -0400
Received: from verein.lst.de ([213.95.11.210]:34427 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0IWIGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:06:11 -0400
Date: Thu, 23 Sep 2010 10:05:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] floppy: switch to one queue per drive instead of  sharing a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel  OOPs when usb key  is inserted")
Message-ID: <20100923080551.GA22764@lst.de>
References: <20100920130318.GA29565@lst.de> <4C975DCC.9050902@fusionio.com> <20100920223001.GJ6138@redhat.com> <20100921182529.GA31132@redhat.com> <4C992F12.5090000@fusionio.com> <20100922204216.GA7487@redhat.com> <4C9B08CF.6000504@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9B08CF.6000504@fusionio.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 09:59:11AM +0200, Jens Axboe wrote:
> Great! So the question is if other drivers with shared queues remain.

A lot of the other floppy drivers are copy & paste job from floppy.c, so
I'd start looking there.

