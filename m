Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2CLPZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:25:15 -0400
Received: from 1wt.eu ([62.212.114.60]:63178 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2CLPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:25:13 -0400
Date: Mon, 12 Mar 2012 16:24:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org, Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312152453.GB12405@1wt.eu>
References: <20120312002046.041448832@1wt.eu> <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com> <20120312063027.GB8971@1wt.eu> <20120312064855.GB16820@burratino> <20120312085820.GA11569@1wt.eu> <20120312152004.GB9380@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312152004.GB9380@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 08:20:04AM -0700, Greg KH wrote:
> > > Two relevant patches:
> > > 
> > >   f7e5ea17 (am: learn passing -b to mailinfo, 2012-01-16)
> > >   ee2d1cb4 (mailinfo: with -b, keep space after [foo], 2012-01-16)
> > > 
> > > are in "master" and 1.7.10-rc0 and were not part of any earlier release.
> > >
> > > Kudos to Thomas for writing them.
> > 
> > Ah, thank you very much for this useful info, I'll update my version !
> 
> I don't see a -b option to 'git am' in the manpage, am I missing
> something here?

It's in the master tree only right now, and the option is "--keep-non-patch"
(could have been shorter). Currently rebuilding to test it :-)

Willy

