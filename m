Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0IJGdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:33:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0IJGdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xTpJd1g0IWYdXcjbs08LI1G51yI3mZ5ymvD0mWVujEJhKgJDD3l0zXTrQvBsBhdA7z
         SfQHnmTcj0ABg4YETx+NC92op+vX0UimfDHIVSedrT1Q/CD34+t9OFt5NFU25AJJlJDZ
         H+fpzxnxF52ggIKZa31mhr/Tr4YzhMBOXnZAQ=
Date: Thu, 9 Sep 2010 23:32:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Stuart Longland <redhatter@gentoo.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100910063253.GA5895@core.coreip.homeip.net>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
 <4C88D668.7030501@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88D668.7030501@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:43:20PM +0100, Jonathan Cameron wrote:
> ....
> > 
> > Likewise with the PIR sensor, I notice there's a "gesture" input
> > (MSC_GESTURE)... seems appropriate?  Or am I barking up the wrong tree?
> Does it look like a button (e.g. is it a straight on off device with
> no control parameters etc)? Dmitry, what would you put this as and would
> this be acceptable in input?  

Phone guys made me add SW_FRONT_PROXIMITY at some point which is
supposed to be reported when someone covers phone screen with something
(puts into pocket or talks holding against the cheek). Could be used
here as well...

-- 
Dmitry
