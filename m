Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2FGRg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:36:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21193 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab2FGRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:36:54 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
In-Reply-To: <m21ulrjbji.fsf@firstfloor.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org>
	 <20120606215034.257d7549@pyramind.ukuu.org.uk>
	 <m21ulrjbji.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 11:36:53 -0600
Message-ID: <1339090613.25761.888.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 10:07 -0700, Andi Kleen wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> This protects against the case where a piece of hardware is continuing 
> >> to DMA even after the driver shutdown method has been called? I'm not 
> >
> > It doesn't. We also have hardware which craps itself if you clear the bus
> > mastering bit and we have platforms where the BIOS gets most upset if you
> > do that on suspend paths. There are also lots of devices that simply
> > ignore the bus mastering bit !
> 
> But it also makes my system do kexec successfully for the first time.
> 
> Maybe can make it an option.
> 
> n-Andi
> 

Hi Andi,

That makes my day :) It will be very helpful to see which PCI devices
your system has.

I was thinking about kernel command line option this morning and had
started looking at reset_devices option to see if I could leverage that
one in any way.

-- 
====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

