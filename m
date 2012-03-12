Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2CLGak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:30:40 -0400
Received: from 1wt.eu ([62.212.114.60]:63140 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab2CLGaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:30:35 -0400
Date: Mon, 12 Mar 2012 07:30:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
Message-ID: <20120312063027.GB8971@1wt.eu>
References: <20120312002046.041448832@1wt.eu> <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312024948.GB4650@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 07:49:48PM -0700, Greg KH wrote:
> On Mon, Mar 12, 2012 at 01:07:26AM +0000, Ben Hutchings wrote:
> > On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > The subject/first line should include '[IA64]', as in the original
> > commit.  It looks like this has been automatically stripped.
> 
> Yeah, munging patches to and from quilt and git will cause that to
> happen at times, it's quite common :(

Indeed, and I've even changed my patch formats in haproxy to avoid brackets
due to this issue. The cause is that many patches are sent with a [PATCH]
prefix and that with Git, either you keep the subject line intact or you
remove everything that is between brackets. There's the -b option to only
remove remove tags looking like [PATCH], but my general experience with it
was not satisfying (I don't remind why). I have added some scripts to do
this at some points in the process but it's not 100% reliable as can be
seen here.

The "funny" thing here is that this comment lacking any IA64 tag annoyed
me a bit, and I was about to change its name then refrained from doing
so because I prefered not to keep the original message intact as I did
not notice the tag went off on my side :-/

Ben, I strongly suggest that you too switch your practise from "[IA64]"
to "IA64:" as can be seen on many kernel commits these days.

Thanks,
Willy

