Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0JSDet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:34:49 -0400
Received: from kroah.org ([198.145.64.141]:37244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab0JSDes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:34:48 -0400
Date: Mon, 18 Oct 2010 20:35:22 -0700
From: Greg KH <greg@kroah.com>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303 ttyUSB0: pl2303_write - failed submitting write urb,
	error -22
Message-ID: <20101019033522.GA32577@kroah.com>
References: <20101018102001.M46961@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018102001.M46961@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 03:52:33PM +0530, Raju Rameshwar Uprade wrote:
> Hi,
>     When I am trying to write some data bytes ..I am getting the following error when I
> look into the kernel log messages.
> 
> pl2303 ttyUSB0: pl2303_write - failed submitting write urb, error -22
> 
> kindly help me in resolving this error.

What kernel version are you using?

thanks,

greg k-h
