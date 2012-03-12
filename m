Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2CLT0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:26:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40676 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab2CLT0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:26:30 -0400
X-Sasl-enc: siAL/JBS/MGfrzVwl9i0lY7VEjYKiHw61AirTzWIll+c 1331580388
Date: Mon, 12 Mar 2012 12:26:27 -0700
From: Greg KH <greg@kroah.com>
To: Junio C Hamano <gitster@pobox.com>
Cc: Willy Tarreau <w@1wt.eu>, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, git@vger.kernel.org,
        Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312192627.GA24873@kroah.com>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
 <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <7vfwddu60f.fsf@alter.siamese.dyndns.org>
 <20120312171257.GA25347@kroah.com>
 <7vzkblsnos.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vzkblsnos.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:01:55AM -0700, Junio C Hamano wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > Does the flag propagate from 'git quiltimport'?
> 
> I didn't even know the script was shipped as part of the main
> Porcelain until I looked.  I do not think anybody is maintaining it;
> the last update was from the 1.6.2 era.

Ah, so my feeling that I'm the only one using it is true :)

> A tested patch from quilt stakeholders is very much welcomed.

I'll be glad to maintain this if you need me to.  I'll poke around with
it tomorrow to see what needs to be done here.

thanks,

greg k-h
