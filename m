Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1DYXFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:05:00 -0400
Received: from kroah.org ([198.145.64.141]:60447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1DYXE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:04:59 -0400
Date: Mon, 25 Apr 2011 15:54:37 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new strtobool
Message-ID: <20110425225437.GA31808@kroah.com>
References: <a>
 <1303213427-12798-3-git-send-email-jic23@cam.ac.uk>
 <4DADF0D3.3040006@bluewatersys.com>
 <4DAEA862.5040507@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAEA862.5040507@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:33:22AM +0100, Jonathan Cameron wrote:
> On 04/19/11 21:30, Ryan Mallon wrote:
> > On 04/19/2011 11:43 PM, Jonathan Cameron wrote:
> >> No functional changes requires that we eat errors from strtobool.
> >> If people want to not do this, then it should be fixed at a later date.
> > 
> > May as well fix it now or it will get forgotten about. A second patch on
> > top of this can fix the bug.
> What worries me about this 'fix' is that it may well break some 'interesting'
> bit of userspace code.  It would count as a userspace api change, be it
> a fairly minor one.
> 
> Greg, do you thing it's worth returning an error on a non bool value?

No one has ever complained about it, so I doubt it's a big issue.

So I'd say to just leave it as-is for now.

thanks,

greg k-h
