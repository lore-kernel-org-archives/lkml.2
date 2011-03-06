Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1CFN2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 08:28:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55297 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1CFN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 08:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ElPXj+A3VsBCyEhPXZg66X6tm+8bMX/IPWqfaecLLsHSvM8w7K3k+KVc1nNBVcK22D
         k/by6iGCK+l4G3QEL2qljn9EJPbQ9RpTOztNtUuOaO/yDGbF3M4xBlcl1DaoEjDljy4x
         VrZeAbtSAhP/IVftdynDv+Cqtw5Pz4DI/2K0c=
Date: Sun, 6 Mar 2011 14:28:36 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110306132834.GA11790@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <1299180844.28285.111.camel@work-vm>
 <20110304064639.GD3824@riccoc20.at.omicron.at>
 <1299355687.28285.130.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299355687.28285.130.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 12:08:07PM -0800, john stultz wrote:
> On Fri, 2011-03-04 at 07:46 +0100, Richard Cochran wrote:
> > I do think a software only PHC will make it easier for people to get
> > started with the new interface. I have been carrying along such a
> > patch privately for my own testing.
> 
> Consistency is but a hobgoblin... :)
> 
> But seriously, do forgive me if I misunderstood your earlier patches
> with this respect. I thought it was just exporting CLOCK_REALTIME
> directly through a new interface/clockid (which would be duplicative).

You are right, I was doing that, but the purpose was for testing.

I am not sure where Torben is going with his idea. In order to figure
out meaningful clock adjustments, you need the clock's timestamps on
the PTP packet tx/rx events. Implementing an internal clock correction
with no connection to the network stack might still be interesting,
but I think having the timestamps is much more useful.

Let's wait and see what Torben says once he come back from travel.

Thanks,

Richard
