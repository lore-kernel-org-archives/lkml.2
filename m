Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161129Ab2COQ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:58:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44591 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161097Ab2COQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:58:16 -0400
Date: Thu, 15 Mar 2012 09:58:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 3.0.24
Message-ID: <20120315165812.GA10397@kroah.com>
References: <20120312203451.GA16773@kroah.com>
 <20120315162322.GA26005@foursquare.net>
 <20120315163749.GA25001@kroah.com>
 <20120315165108.GA27737@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165108.GA27737@foursquare.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:51:08PM -0400, Chris Frey wrote:
> > > When I read it, it looks like there are serious patches included in
> > > this release, perhaps data integrity or security patches.  But "must"
> > > has been in an awful lot of these release notes lately, that it makes
> > > me wonder if it is boilerplate.
> > > 
> > > Just curious how to interpret this.
> > 
> > Interpret it as written please.
> 
> Perhaps it would help if I phrased my question differently: What kind of
> bug makes you decide to write "must" instead of something else?

This has been discussed endlessly in the past, please see the lkml
archives for details if you are interested.  It all comes down to the
issue, how do you classify a bug fix as a specific "kind"[1]?

Is there some reason you don't trust me in my usage of the word "must"
here?  If so, then please feel free to go through all of the individual
patches, which I post, and make the judgement call for yourself.

thanks,

greg k-h

[1] Hint, for the most part, you can't.
