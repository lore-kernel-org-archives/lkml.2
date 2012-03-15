Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031827Ab2COR2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:28:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48280 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242Ab2COR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:28:31 -0400
X-Originating-Ip: 216.16.235.2
Date: Thu, 15 Mar 2012 13:28:28 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Linux 3.0.24
Message-ID: <20120315172828.GA29721@foursquare.net>
References: <20120312203451.GA16773@kroah.com> <20120315162322.GA26005@foursquare.net> <20120315163749.GA25001@kroah.com> <20120315165108.GA27737@foursquare.net> <20120315165812.GA10397@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165812.GA10397@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:58:12AM -0700, Greg KH wrote:
> On Thu, Mar 15, 2012 at 12:51:08PM -0400, Chris Frey wrote:
> > Perhaps it would help if I phrased my question differently: What kind of
> > bug makes you decide to write "must" instead of something else?
> 
> This has been discussed endlessly in the past, please see the lkml
> archives for details if you are interested.  It all comes down to the
> issue, how do you classify a bug fix as a specific "kind"[1]?
> 
> Is there some reason you don't trust me in my usage of the word "must"
> here?  If so, then please feel free to go through all of the individual
> patches, which I post, and make the judgement call for yourself.
> 
> [1] Hint, for the most part, you can't.

It's not a matter of trust, but of understanding.  If, according to your
footnote, you do not classify bugs at all (except maybe compile issues,
as Jonathan mentioned), then "must" merely implies that "a bug was fixed."

But had you classified bugs, then it would be useful to know what
criteria you had used.  And if so, it would make sense that such criteria
would be documented somewhere.

I had assumed the latter case, but it seems that the former is more accurate.

Thanks, both to you and Jonathan for clarifying my misunderstanding.

- Chris

