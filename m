Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2EHAbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:31:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab2EHAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:31:07 -0400
Date: Mon, 7 May 2012 17:31:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Chen <peter.chen@freescale.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chen Peter-B29397 <B29397@freescale.com>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Subject: Re: [ 23/47] [PATCH] Revert "usb: Fix build error due to dma_mask is
 not at pdev_archdata at ARM"
Message-ID: <20120508003102.GB4150@kroah.com>
References: <20120504204246.865253021@linuxfoundation.org>
 <1336355988.8274.263.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336355988.8274.263.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 02:59:48AM +0100, Ben Hutchings wrote:
> On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > This reverts commit d39514c14bd941232976b68e2750dc725b90e724 which is
> > e90fc3cb087ce5c5f81e814358222cd6d197b5db upstream as it causes oopses on
> > some ppc systems.
> [...]
> 
> Is this needed for 3.2.y as well?

I do not think so.

greg k-h
