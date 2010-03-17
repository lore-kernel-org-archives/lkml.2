Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0CQJRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:17:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:39947 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0CQJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eT/rek8U1yLtwT6emBKnztCZRxIhHpZBjsPaaFyrXPyej5NLljVD9ge00NWa0CKPKL
         4V1mN6KXf/QinluQgPav0tBV6I5iMTHE2ylPswN0xW/k1mJWl3eEovSHIyvwfThkl+yx
         j5B5y3RIu2HtnwrWgnpA3cPhn5G44n6pw8qxc=
Date: Wed, 17 Mar 2010 10:16:59 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Feuerer <peter@piie.net>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2] USB: pl2303: switch to generic write implementation
Message-ID: <20100317091659.GC18570@localhost>
References: <201003031608.20277.oliver@neukum.org>
 <1267701172-9549-1-git-send-email-jhovold@gmail.com>
 <20100315232004.GB21339@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315232004.GB21339@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 04:20:05PM -0700, Greg KH wrote:
> On Thu, Mar 04, 2010 at 12:12:52PM +0100, Johan Hovold wrote:
> > Replace custom fifo-based write implementation with the generic
> > kfifo-based one.
> 
> What kernel is this patch against?  For some reason it doesn't apply to
> my tree right now :(
 
It's against 2.6.33 (the bug report in question was against 2.6.32.9 so
I figured I'd rebase it against stable at least).

> Care to respin it?

I'll submit it along with some other patches shortly.

Thanks,
Johan

