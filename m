Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129Ab2FHQhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:37:41 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49359 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:37:40 -0400
Date: Fri, 8 Jun 2012 18:37:29 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608163728.GD9705@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <1339165738.3870.18.camel@blech>
 <20120608151843.GA9705@local>
 <1339170312.26423.6.camel@tesla>
 <20120608155728.GB9705@local>
 <1339172599.26423.13.camel@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339172599.26423.13.camel@tesla>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:23:19PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 17:57 +0200 schrieb Hans J. Koch:
> > What problem do you have with this approach?
> 
> Nothing itself. There is obviously a documentation issue, which really
> confuses people who are new to that stuff.

Well, the documentation says "Userspace driver can use pci sysfs interface,
or the libpci libray that wraps it, to talk to the device..."

I agree that this is not very clear, especially since the example code there
doesn't use this.

> I thought that fixing it, by
> just adding a view lines of code (really a view, when I remove the DMA
> masque part) might enhance this particular module.

I'm not sure if talking to the device the UIO way can confuse the PCI
subsystem. Are you? Any hints from somebody else?

Unfortunately, I can't remember why we agreed to do it the way it is...

> 
> Anyway, what is wrong when the uio_pci_generic module works like
> described in the related documentation?

It does, the documentation is just not very explicit when it comes to
memory mapping.

Thanks,
Hans
