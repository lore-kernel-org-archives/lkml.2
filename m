Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1FIPWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:22:37 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46392 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1FIPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LtA+I69nX+IUpRzsJhyJwCSLVS26EGIcYtLqyabJeS4Jnt6K750L1OSkHJ6pzkUXYm
         ozYKQ0l310jg+XIKnMnGwWavgtdkKkxxyPXqd4O9flnr0JEv367MJbOnN7L3NcyQ9NZT
         yxkJe/KsnUtfoiRFVf+yEoAOrgOI6XMlvpmwA=
Date: Thu, 9 Jun 2011 19:22:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110609152225.GH6699@sun>
References: <4DD07959.4030608@intel.com>
 <20110516190310.GH31888@redhat.com>
 <4DD20A2F.604@intel.com>
 <20110517142427.GL31888@redhat.com>
 <20110517163847.GF24805@tassilo.jf.intel.com>
 <20110517175707.GP31888@redhat.com>
 <20110517181859.GA25937@tassilo.jf.intel.com>
 <20110517190738.GH29881@redhat.com>
 <4DD622A5.9030902@intel.com>
 <20110609120928.GR8162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609120928.GR8162@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 08:09:28AM -0400, Don Zickus wrote:
...
> Perhaps I am a bit naive in my belief but I am a little nervous panicing
> all the time on unknown NMIs when we are still chasing missed perf NMIs on
> a loaded box.
> 
> Cheers,
> Don
> 

Agreed, though I always vote for notifier chain (with either CONFIG_ option
or command line one) so there would be a way to turn panic off if needed.
I believe there is a way to make such NMI handler being with highest priority
and Ying will be able to do with it whatever he wants -- panic, warning,
or even immediate reboot, whatever ;)

	Cyrill
