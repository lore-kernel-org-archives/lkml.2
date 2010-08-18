Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0HRVn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:43:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59161 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0HRVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U0I0XsOY98mdEXxH3uLWVKwVxGreSS3Rmr1RzGzpmMmp9yK74fvLQ2IpRFkp7WhZJ2
         cWC5ubMotPyx7uoWZf/OwTW2jlJJbeJPlJw8kHHpCGdAIpp42UxIvua3RB8JPGhKhUlX
         enhcks7Vg6WoTWrEWX2vOLEt4yEXm179teywc=
Date: Wed, 18 Aug 2010 23:34:29 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
	from invalid context
Message-ID: <20100818213428.GB4132@linux-m68k.org>
References: <20100817145305.GA7342@linux-m68k.org> <20100818133459.GA6663@kroah.com> <20100818140335.GB18303@linux-m68k.org> <20100818143927.GA1202@kroah.com> <20100818200057.GA4132@linux-m68k.org> <20100818201751.GA31825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818201751.GA31825@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 01:17:51PM -0700, Greg KH wrote:

> > Unfortunately no improvemenet with the hibernation problem that is there since
> > 2.6.35?
> 
> That's different, right?

yes. I thought perhaps it might be this 
  http://lkml.org/lkml/2010/8/6/7

suspend to ram works fine.

> And .34 works for you?  Can you run 'git bisect' on the tree to find the
> offending patch?

2.6.34 works. Bisect could take ages for me but I would try it as last resort.


Richard
