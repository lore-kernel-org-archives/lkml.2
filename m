Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2CLPUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:20:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45739 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906Ab2CLPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:20:07 -0400
X-Sasl-enc: Y6jXSRQXU2Kyh+mhu1WjL8barKj8mt4URWeewBuzDTLq 1331565605
Date: Mon, 12 Mar 2012 08:20:04 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org, Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312152004.GB9380@kroah.com>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
 <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312085820.GA11569@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:58:20AM +0100, Willy Tarreau wrote:
> Hi Jonathan,
> 
> On Mon, Mar 12, 2012 at 01:48:55AM -0500, Jonathan Nieder wrote:
> > > Indeed, and I've even changed my patch formats in haproxy to avoid brackets
> > > due to this issue. The cause is that many patches are sent with a [PATCH]
> > > prefix and that with Git, either you keep the subject line intact or you
> > > remove everything that is between brackets. There's the -b option to only
> > > remove remove tags looking like [PATCH], but my general experience with it
> > > was not satisfying (I don't remind why).
> > 
> > Maybe the problem was as simple as "git am" not knowing about "-b".
> 
> I think you're quite right.
> 
> > Two relevant patches:
> > 
> >   f7e5ea17 (am: learn passing -b to mailinfo, 2012-01-16)
> >   ee2d1cb4 (mailinfo: with -b, keep space after [foo], 2012-01-16)
> > 
> > are in "master" and 1.7.10-rc0 and were not part of any earlier release.
> >
> > Kudos to Thomas for writing them.
> 
> Ah, thank you very much for this useful info, I'll update my version !

I don't see a -b option to 'git am' in the manpage, am I missing
something here?

greg k-h
