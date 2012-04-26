Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2DZVQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:16:38 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55334 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2DZVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:16:36 -0400
Date: Thu, 26 Apr 2012 14:16:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Partha Basak <p-basak2@ti.com>
Subject: Re: [ 43/62] usb: gadget: udc-core: fix asymmetric calls in
 remove_driver
Message-ID: <20120426211632.GC372@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.670329887@linuxfoundation.org>
 <20120426003435.GI3932@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426003435.GI3932@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 01:34:35AM +0100, Ben Hutchings wrote:
> On Tue, Apr 24, 2012 at 03:33:24PM -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kishon Vijay Abraham I <kishon@ti.com>
> > 
> > commit 8ae8090c82eb407267001f75b3d256b3bd4ae691 upstream.
> > 
> > During modprobe of gadget driver, pullup is called after
> > udc_start. In order to make the exit path symmetric when
> > removing a gadget driver, call pullup before ->udc_stop.
> [...]
>  
> It looks like commit 6d258a4c42089229b855fd706622029decf316d6
> (previous patch in this series!) added another case where the
> cleanup functions are called in the wrong order.

Felipe?  Any thoughts?
