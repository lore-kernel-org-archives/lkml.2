Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab1CDVv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:51:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64778 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217Ab1CDVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YwSNG/FABYqH2JZlu4AcOh+uB51czM+PNTpFYR5TFIpISlIv3wPyqr2Z9S369nUSw5
         0gbInYCHu3BfjcZtWtINpVYBvYd0emSk/EVGxVNeITjf1yAwN46SFv2DM2zql7QxyyU9
         +NbiSKfv2Yj+GFMqmTUqaC+Z3Q/xV7NefYqjw=
Date: Sat, 5 Mar 2011 00:51:20 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, security@kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Security] [PATCH] power: disable hibernation if module
 loading is disabled
Message-ID: <20110304215118.GA30253@albatros>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <20110304212709.GA28680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304212709.GA28680@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 13:27 -0800, Greg KH wrote:
> On Fri, Mar 04, 2011 at 07:11:24PM +0300, Vasiliy Kulikov wrote:
> > If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> > root) may not read/write arbitrary kernel memory.  In spite of it,
> > hibernation allows anyone with an access to either /dev/snapshot or
> > /sys/power/ make the full snapshot of the system.  This snapshot may be
> > freely changed and uploaded back.
> 
> This sounds like a very unintentional change to the "don't load any
> modules" option, right?  If so, you should really document this
> somewhere, otherwise people are going to get very confused when their
> system suspends suddenly stop working for no obvious reason.

Agreed, thank you.  Is Documentation/sysctl/kernel.txt an appropriate
place?

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
