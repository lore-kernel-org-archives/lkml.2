Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1ATL1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:27:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:45323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1ATL1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:27:23 -0500
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
	 <1295484358.15213.25.camel@yhuang-dev>
	 <20110119165247.cca2f434.akpm@linux-foundation.org>
	 <1295520247.28776.152.camel@laptop>
	 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 12:27:56 +0100
Message-ID: <1295522876.28776.158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 19:18 +0800, huang ying wrote:
> >
> > In fact, I have a patch ready and waiting to revert the whole irq_work
> > stuff, that too seems to be a superfluous generalization.
> 
> What do you plan to replace irq_work?  I plan to use it in APEI NMI
> handler and MCE handler. 

But will all that stuff be accepted? Please stop sending infrastructure
bits and focus on your larger RAS picture, once you have consensus on
that from all parties involved, then, and only then, does it make sense
to submit everything, including infrastructure.

As it stands now you're simply submitting infrastructure without any
users, and we all know the RAS thing isn't settled, so those users might
never come..


