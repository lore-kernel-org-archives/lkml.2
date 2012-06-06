Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2FFXEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:04:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23307 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFXEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:04:02 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <CAL-B5D3Wda7TV_NBJWEbzJm=0eCs=b-wgGLdJUFRTwP_ewXGGg@mail.gmail.com>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org> <1338999463.25761.630.camel@lyra>
	 <20120606162703.GA6779@srcf.ucam.org> <1339003956.25761.667.camel@lyra>
	 <20120606174202.GA8750@srcf.ucam.org> <1339006060.25761.689.camel@lyra>
	 <CAL-B5D3Wda7TV_NBJWEbzJm=0eCs=b-wgGLdJUFRTwP_ewXGGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 17:03:59 -0600
Message-ID: <1339023839.25761.764.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:16 -0600, Myron Stowe wrote:
> Hay Khalid,
> 
> I've been following this discussion but still do not understand what the
> perceived correct fix is for the situation you were originally trying to
> circumvent - namely, stopping NIC devices from triggering DMA activity
> upon receipt of an incoming packet.
> 
> From the discussion it sounds like a driver, upon shutdown, can end
> all active I/O
> clearing the I/O queue, and also (?) shut down its DMA engine, and may
> also go as far as disabling the Bus Master bit.
> 
> What was occurring in the original issue - was the driver in question not
> shutting down its DMA engine for some, possibly valid, reason?
> 
> Thanks,
>  Myron

Hi Myron,

The last driver issue with kexec was reported on kexec mailing list in
July of last year and that was with qla driver. From what H Peter Anvin
described, the driver left DMA engine running.

For the issue I found on an ia64 platform, it was so many years ago that
you are now taxing my old and decrepit memory :) I am digging through
old internal bug reports and will let you know once I find that original
bug report.

====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

