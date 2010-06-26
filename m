Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0FZRFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 13:05:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab0FZRFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 13:05:03 -0400
Date: Sat, 26 Jun 2010 10:04:17 -0700
From: Greg KH <gregkh@suse.de>
To: Nils Radtke <Nils.Radtke@Think-Future.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.33.4 PATCH] V4L/uvcvideo: Add support for Suyin Corp.
 Lenovo Webcam
Message-ID: <20100626170417.GB1135@suse.de>
References: <20100623092316.GA13364@localhost>
 <201006231445.54883.laurent.pinchart@ideasonboard.com>
 <20100624181941.GE13364@localhost>
 <201006250929.29621.laurent.pinchart@ideasonboard.com>
 <20100626103615.GE8384@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626103615.GE8384@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 12:36:15PM +0200, Nils Radtke wrote:
> Isn't the vendor/product ID a point of reference that tells the kernel which module
> to load when supported hw is found? That was the idea behind adding the ID and
> submitting the patch. 

No, it also triggers off of the class information of the device, which
your device says it supports.  If we had to add every single unique
device id for usb keyboards, that would be a mess :)

thanks,

greg k-h
