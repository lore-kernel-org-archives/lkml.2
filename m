Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205Ab2FHRHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:07:30 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:54134 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120Ab2FHRH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:07:28 -0400
Message-ID: <1339175266.26423.20.camel@tesla>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 19:07:46 +0200
In-Reply-To: <20120608163728.GD9705@local>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <1339165738.3870.18.camel@blech>
	 <20120608151843.GA9705@local> <1339170312.26423.6.camel@tesla>
	 <20120608155728.GB9705@local> <1339172599.26423.13.camel@tesla>
	 <20120608163728.GD9705@local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.06.2012, 18:37 +0200 schrieb Hans J. Koch:
> It does, the documentation is just not very explicit when it comes to
> memory mapping. 

OK, quoting the other mail:

Am Freitag, den 08.06.2012, 19:39 +0300 schrieb Michael S. Tsirkin:

> Documentation says this:
> 
>         Userspace driver can use pci sysfs interface, or the
>         libpci libray that wraps it, to talk to the device and to
>         re-enable interrupts by writing to the command register. 

I think should ditch the discussion about the patch and I'm going to
revise the documentation? I read this part a couple of times and allways
thought the "sysfs interface" refers to the UIO sysfs entry. 

Therefore, would it be OK if I send a patch for the documentation next
week?

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 (0)

