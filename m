Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1CUUOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:14:32 -0400
Received: from kroah.org ([198.145.64.141]:56356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1CUUOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:14:30 -0400
Date: Mon, 21 Mar 2011 13:14:11 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: Standard handling of boolean attributes in sysfs.
Message-ID: <20110321201411.GA1704@kroah.com>
References: <4D87AEE0.8000807@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D87AEE0.8000807@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:02:40PM +0000, Jonathan Cameron wrote:
> Hi All,
> 
> Just wondering what the feeling would be about having
> a utility function similar to sysfs_streq to provide a
> consistent option for all those sysfs attributes out there
> where
> 
> 1, on, true -> 1
> 0, off, false -> 0
> 
> Or does such a beast already exist and I'm just being unobservant?

We have the one in debugfs that I think people use for sysfs.  Have you
looked at that?

thanks,

greg k-h
