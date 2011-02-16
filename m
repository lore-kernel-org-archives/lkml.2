Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1BPQsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:48:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48760 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1BPQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lvf+zJobf7Js79o586VIReezhAtS/lwokA/2W7cxUls/5ibfsy0sozuv9XB41C21Sr
         sGC2Hyy3dTo6gdwdyW/nWyqLjnUvK4w4jpf2sJlymh8VFZsbuMJda27nuSH8Auq/y0Ij
         3aDvm/qSWYG1VKM8VzJKHycz3JSILGEONH6pk=
Date: Wed, 16 Feb 2011 08:48:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH] workqueue, freezer: unify spelling of 'freeze' + 'able'
 to 'freezable'
Message-ID: <20110216164830.GB29796@core.coreip.homeip.net>
References: <20110216083442.GB19830@htj.dyndns.org>
 <20110216151829.GC3550@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216151829.GC3550@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 07:18:29AM -0800, Greg KH wrote:
> On Wed, Feb 16, 2011 at 09:34:42AM +0100, Tejun Heo wrote:
> > There are two spellings in use for 'freeze' + 'able' - 'freezable' and
> > 'freezeable'.  The former is the more prominent one.  The latter is
> > mostly used by workqueue and in a few other odd places.  Unify the
> > spelling to 'freezable'.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Alex Dubov <oakad@yahoo.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 

Thanks for doing this Tejun.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
