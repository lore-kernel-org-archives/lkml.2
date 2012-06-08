Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143Ab2FHQj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:39:58 -0400
Date: Fri, 8 Jun 2012 19:39:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608163950.GA3344@redhat.com>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <1339165738.3870.18.camel@blech>
 <20120608151843.GA9705@local>
 <1339170312.26423.6.camel@tesla>
 <20120608155728.GB9705@local>
 <1339172599.26423.13.camel@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339172599.26423.13.camel@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:23:19PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 17:57 +0200 schrieb Hans J. Koch:
> > What problem do you have with this approach?
> 
> Nothing itself. There is obviously a documentation issue, which really
> confuses people who are new to that stuff. I thought that fixing it, by
> just adding a view lines of code (really a view, when I remove the DMA
> masque part) might enhance this particular module. 
> 
> Anyway, what is wrong when the uio_pci_generic module works like
> described in the related documentation? 

Documentation says this:

	Userspace driver can use pci sysfs interface, or the
	libpci libray that wraps it, to talk to the device and to
	re-enable interrupts by writing to the command register.

maybe we should make the point that *all* interaction with
the device should be done via sysfs, explicit.

> -- 
> Gruß
>   Dominic
> 
> Frankfurt Institute for Advanced Studies (FIAS)
> Ruth-Moufang-Straße 1
> D-60438 Frankfurt am Main
> Germany
> 
> Phone:  +49 (0)
