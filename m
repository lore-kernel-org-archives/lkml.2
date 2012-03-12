Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2CLSy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:54:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46362 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab2CLSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:54:54 -0400
Date: Mon, 12 Mar 2012 13:54:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Junio C Hamano <gitster@pobox.com>, Thomas Rast <trast@inf.ethz.ch>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org, Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312185440.GA21817@burratino>
References: <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
 <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu>
 <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu>
 <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
 <20120312165703.GB18791@burratino>
 <7vvcm9snko.fsf@alter.siamese.dyndns.org>
 <20120312185008.GH12405@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312185008.GH12405@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> From my user experience and what I see on a number of coworkers, users
> tend to make big jumps when they need a new feature, so in practice,
> not offering the option in a version or two would probably not affect
> most users, especially the ones still relying on the old behaviour. So
> I don't see much benefit in waiting for repurposing the option.

The benefit is that if it does turn out to be a regression, early
adopters will complain to us because their scripts have stopped
working and we get a chance to back out the change without having to
worry about others who have started to rely on the option.

Regards,
Jonathan
