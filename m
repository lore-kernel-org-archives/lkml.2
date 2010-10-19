Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab0JSNis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:38:48 -0400
Received: from kroah.org ([198.145.64.141]:54522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717Ab0JSNiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:38:46 -0400
Date: Tue, 19 Oct 2010 05:47:13 -0700
From: Greg KH <greg@kroah.com>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303 ttyUSB0: pl2303_write - failed submitting write urb,
 error -22
Message-ID: <20101019124713.GA31828@kroah.com>
References: <20101018102001.M46961@admin-gateway.ncra.tifr.res.in>
 <20101019033522.GA32577@kroah.com>
 <20101019050336.M39015@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019050336.M39015@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:46:51AM +0530, Raju Rameshwar Uprade wrote:
> 
> > What kernel version are you using?
> > 
> 
> I am using kernel version 2.6.25.I cann't use current linux kernel version because it
> uses the generic write function and for my application I need pl2303_write. 

Then you are really on your own here, sorry.

good luck,

greg k-h
