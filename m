Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0J0UWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:22:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60898 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab0J0UWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MvIy+BDG7xnga8zHB2yRYNHkZ8zKb2LlwSZvdO9qroWe8ABBGkzN7GcRxhuUOi4nx2
         sfaChR/o0HpoR3fHozjLv4abAKXSKvbUSDcd75pBwtB73t6s+k5qaUsNf/e8YicvB/C9
         R5K/3/ZxFDGKBvwpiBlpU0kJwtyZCjqESM9+Y=
Date: Thu, 28 Oct 2010 00:22:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [rfc -tip 0/2] Implementing self IPI with NMI destination
Message-ID: <20101027202234.GE5896@lenovo>
References: <20101027195352.996250316@openvz.org> <alpine.LFD.2.00.1010272113001.6079@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010272113001.6079@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:18:33PM +0100, Maciej W. Rozycki wrote:
> On Wed, 27 Oct 2010, Cyrill Gorcunov wrote:
> 
> >  Here is self-IPI with NMI destination implemented. Don was testing
> > perf NMI's and we found that we don't have a simple call for self-nmi IPI.
> 
>  I'm completely swamped with binutils stuff these days, and I've got a 
> couple of outstanding issues to deal with before the imminent 2.21 release 
> -- I'll try to pinch some time and have a look at your patches over the 
> weekend, but please forgive me if I don't (and ping me sometime next week 
> then).
> 
>   Maciej
> 

No problem Maciej, it is _absolutely_ non urgent, just an early RFC.

  Cyrill
