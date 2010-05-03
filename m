Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab0ECVMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:12:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49161
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab0ECVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:12:34 -0400
Date: Mon, 03 May 2010 14:12:40 -0700 (PDT)
Message-Id: <20100503.141240.22516688.davem@davemloft.net>
To: dave@linux.vnet.ibm.com
Cc: orenl@cs.columbia.edu, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, matthltc@us.ibm.com, xemul@openvz.org,
       sukadev@linux.vnet.ibm.com, linux-api@vger.kernel.org, x86@kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272920551.12034.4729.camel@nimitz>
References: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
	<20100501.151022.190375136.davem@davemloft.net>
	<1272920551.12034.4729.camel@nimitz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 03 May 2010 14:02:31 -0700

> It has implications _everywhere_.

That does not remove the responsibility to break things up into
managable pieces, not does it make such a task impossible or
even hard to do.

You post sets of 10 to 15 at a time, once those are agreed to
and to everyone's general liking, you toss them into a GIT tree
and you say "here's the next 10 to 15 and they are relative to
the changes in GIT tree X which have already been fully reviewed"

And so on and so forth.

And this is the only logical thing to do, because if someone wants
a change in patch 7, it can effect patch 23 so it's pointless to
post for review a patch that's going to end up changing anyways.
That's a waste of reviewer resources.

To be honest, I'm really tired of what tends to be people's knee jerk
reaction to this situations, which is a lot of people doing nothing
but defending themselves.  Even if it did not violate documented
policy (it did), it violates common sense.  So, can people do
something more constructive than trying to defend themselves on this?

It's stupid and shouldn't have been done, and we should move on.



