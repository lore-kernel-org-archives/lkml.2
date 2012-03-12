Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2CLRNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:13:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36981 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185Ab2CLRM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:12:59 -0400
X-Sasl-enc: 1s/OHC/aXfWIplQzdjCWp8rKi6WCFr5NZ/JZylV0IeAV 1331572378
Date: Mon, 12 Mar 2012 10:12:57 -0700
From: Greg KH <greg@kroah.com>
To: Junio C Hamano <gitster@pobox.com>
Cc: Willy Tarreau <w@1wt.eu>, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, git@vger.kernel.org,
        Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312171257.GA25347@kroah.com>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
 <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <7vfwddu60f.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vfwddu60f.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:40:48AM -0700, Junio C Hamano wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > I don't see a -b option to 'git am' in the manpage, am I missing
> > something here?
> 
> As this is a recent enhancement, it is very much appreciated if you
> try out 1.7.10-rc0 (or 'master').

Nice, I'll go do that now.

Does the flag propagate from 'git quiltimport'?  That's how I import
patches that would need this option most of the time.

thanks,

greg k-h
