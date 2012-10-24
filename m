Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab2JXDCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:02:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49647 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab2JXDCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:02:46 -0400
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, peterz@infradead.org,
        mingo@redhat.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com
In-Reply-To: <alpine.LFD.2.02.1210240004410.2756@ionos>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>
	 <1350978723.8609.1555.camel@edumazet-glaptop>
	 <alpine.LFD.2.02.1210232345200.2756@ionos>
	 <1351029216.6537.3.camel@edumazet-glaptop>
	 <alpine.LFD.2.02.1210240004410.2756@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 05:02:40 +0200
Message-ID: <1351047760.6537.6.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 00:33 +0200, Thomas Gleixner wrote:
> On Tue, 23 Oct 2012, Eric Dumazet wrote:
> 
> > On Tue, 2012-10-23 at 23:47 +0200, Thomas Gleixner wrote:
> > 
> > > Not so good to me.
> > >  
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > 
> > > And that should be either an Acked-by or a Reviewed-by. You can't sign
> > > off on patches which have not been submitted or transported by you.
> > 
> > I actually gave some input, provided a hash function, and so on.
> > 
> > So this SOB was valid. I do that all the time.
> 
> Not really. I recommend you to read the relevant file in Documentation
> which covers what can have your SOB. 

OK I did that again, and found this :

The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery
path.


And I was involved in the development of the patch.

I understand you dont like it at all, so I'll remember not trying to
help anymore in this area.



