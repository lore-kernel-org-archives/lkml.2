Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0CRU7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:59:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CRU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MPbM8ofFvGF2+8D6tI21ojn30ZlgvFHfmSQzHptF0OIQk63l25DnwxVX4hswUFlLkI
         Aw8zN3Dvhxwi7mPknFuYUoTGbNi3LbECDAATGXr1RbHYoirOi1r974tY8XDNfr4T06GO
         zkMc7VCpfsAcVpjdgF0tj2TGeQpDE6+2bEtdY=
Date: Thu, 18 Mar 2010 23:59:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] x86,perf: add cache events in p4 PMU
Message-ID: <20100318205949.GG5062@lenovo>
References: <1268908392.13901.128.camel@minggr.sh.intel.com> <20100318155610.GA28061@elte.hu> <20100318160135.GD5062@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318160135.GD5062@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 07:01:35PM +0300, Cyrill Gorcunov wrote:
[...]
> > So i've applied your patches. Cyrill, what do you think?
> 
> Sorry for a bit delay, yes, pick it up please. I found that we have an
> issue in escr binding (which is pretty mine error), hope to fix it up
> today. Also I hope to eventually implement raw events this weekend
> but better to base the new code on all this stuff merged. This will
> allow to "take a look" on code structure from a high point and find
> potential caveats.
> 
> All-in-one
> 
> Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> Thanks a huge, Ming!
> 
> > 
> > 	Ingo
> > 
> 	-- Cyrill

Ok, the issue I thought about not really exist. Misfire :)

	-- Cyrill
