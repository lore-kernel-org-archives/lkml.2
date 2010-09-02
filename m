Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab0IBESW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 00:18:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:58779 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0IBESV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 00:18:21 -0400
Subject: RE: Memory allocation modifications in ibm_newemac driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>
	 , <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>
	 <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 14:18:12 +1000
Message-ID: <1283401092.16240.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 22:04 +0000, Jonathan Haws wrote:
> Okay, I think I have all the issues worked out and can now send and
> receive any size packet without a hiccup.  I have tested this in our
> system setup as well with data being sent out to disk and did not see
> any problems there either (since it only ever allocates a single page,
> never more).
> 
> Is this something that may be wanted in the mainline?  I have not run
> full benchmarks, but I anticipate that my modified driver is slightly
> slower than the mainline driver because we keep track of an SKB ring,
> as well as a ring of pages and allocate both on each packet received.

Well, it won't hurt to post the patch to review :-)

Make sure to CC me as I more/less maintain that driver.

Cheers,
Ben.


