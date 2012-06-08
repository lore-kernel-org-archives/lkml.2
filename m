Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2FHPo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:44:57 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:47517 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab2FHPo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:44:56 -0400
Message-ID: <1339170312.26423.6.camel@tesla>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 17:45:12 +0200
In-Reply-To: <20120608151843.GA9705@local>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <1339165738.3870.18.camel@blech>
	 <20120608151843.GA9705@local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.06.2012, 17:18 +0200 schrieb Hans J. Koch:
> Then there's something fundamentally wrong in your driver. Check the
> return value of uio_register_device().
> 
I'm talking about the uio_pci_generic module, not about UIO in general.

> > I was very confused when I tried UIO the first time
> > and it did not behave like it is described in the documentation.
> 
> UIO is the mainline since 2007, and I can assure you it works like
> described. Lots of people use it.
> 
I know and I really don't have a problem with UIO itself. The
uio_pci_generic module does not export correctly, maybe you take a look
on its code? My guess is, that the uio_pci_generic module isn't commonly
used and therefore the problem wasn't reported before.

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 (0)

