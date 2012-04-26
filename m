Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2DZAel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:34:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54699 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932682Ab2DZAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:34:40 -0400
Date: Thu, 26 Apr 2012 01:34:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Partha Basak <p-basak2@ti.com>
Message-ID: <20120426003435.GI3932@decadent.org.uk>
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.670329887@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223245.670329887@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 43/62] usb: gadget: udc-core: fix asymmetric calls in
 remove_driver
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:33:24PM -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kishon Vijay Abraham I <kishon@ti.com>
> 
> commit 8ae8090c82eb407267001f75b3d256b3bd4ae691 upstream.
> 
> During modprobe of gadget driver, pullup is called after
> udc_start. In order to make the exit path symmetric when
> removing a gadget driver, call pullup before ->udc_stop.
[...]
 
It looks like commit 6d258a4c42089229b855fd706622029decf316d6
(previous patch in this series!) added another case where the
cleanup functions are called in the wrong order.
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
