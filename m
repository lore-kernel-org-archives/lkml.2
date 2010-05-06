Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0EFC2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:28:19 -0400
Received: from ozlabs.org ([203.10.76.45]:52231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab0EFC2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:28:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: dedekind1@gmail.com
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Date: Thu, 6 May 2010 11:58:12 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
References: <200910290902.13724.rusty@rustcorp.com.au> <s5hmxwevlm4.wl%tiwai@suse.de> <1273049369.3702.127.camel@localhost>
In-Reply-To: <1273049369.3702.127.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061158.13098.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010 06:19:29 pm Artem Bityutskiy wrote:
> > Fixing in the way of the later upstream is a bit too intrusive as a
> > stable patch.  So, I'm also not sure whether we should take it,
> > too...
> 
> To be frank I do not really understand what you mean.
> 
> Anyway, I just humbly suggest not to have the "no one uses that, let's
> have a leak" attitude. I do understand that this is a 'it's a lot of
> churn for not much gain'. However, I think the rmmod leak is large
> enough issue.

Thanks Artem, that's exactly the kind of feedback we need.

For most people, module parameters are rare, and module removal is rare.
So the amount of leak is less than the size of the code we would add to fix
it.

If this is hitting you, it clearly changes the priorities.  I will include
the patches now.

Thanks!
Rusty.

