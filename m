Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1ISXPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:15:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34324 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1ISXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:15:10 -0400
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4E77CC0E.2090206@linux.intel.com>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
	 <1316471007.2455.24.camel@edumazet-laptop>
	 <20110919223649.GO7761@one.firstfloor.org>
	 <1316472096.2455.27.camel@edumazet-laptop>
	 <4E77CC0E.2090206@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 01:15:04 +0200
Message-ID: <1316474104.2455.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 19 septembre 2011 à 16:11 -0700, Andi Kleen a écrit :
> > I'll provide not a hack but a clean patch for this.
> 
> Great thanks.
> > I read once idr code, and its not messy at all.
> You're not serious right? Especially the locking scheme is just
> a extreme mess:
> 
> sometimes takes a lock, sometimes requires locking from the caller
> even though the internal lock should be fine, sometimes uses unlocked 
> bitmap
> operations outside a lock, all mixed with a partial RCU implementation,
> no assumption is documented of course.  etc.etc. It's a great poster child
> for messy kernel code.
> 

I dont know, I met more complex code in kernel, but I wont say where ;)



