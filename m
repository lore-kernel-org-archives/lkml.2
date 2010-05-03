Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0ECVCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:02:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37312 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab0ECVCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:02:39 -0400
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: orenl@cs.columbia.edu, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, matthltc@us.ibm.com, xemul@openvz.org,
       sukadev@linux.vnet.ibm.com, linux-api@vger.kernel.org, x86@kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20100501.151022.190375136.davem@davemloft.net>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
	 <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
	 <20100501.151022.190375136.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 03 May 2010 14:02:31 -0700
Message-Id: <1272920551.12034.4729.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-01 at 15:10 -0700, David Miller wrote:
> NO WAY, there is no way in the world you should post 100 patches
> at a time to any mailing list, especially those at vger.kernel.org
> that have thousands upon thousands of subscribers.
> 
> Post only small, well contained, sets of patches at a time.  At most
> 10 or so in one go.

Hi Dave,

I really do apologize if these caused undue traffic on vger.  It
certainly wasn't our intention to cause any problems.

We've had a fear all along that we'll just go back into our little
containers@lists.linux-foundation.org, and go astray of what the
community wants done with these patches.  It's also important to
remember that these really do affect the entire kernel.  Unfortunately,
it's not really a single feature or something that fits well on any
other mailing list.  It has implications _everywhere_.  I think Andrew
Morton also asked that these continue coming to LKML, although his
request probably came at a time when the set was a wee bit smaller.

> Do you realize how much mail traffic you generate by posting so many
> patches at one time, and how unlikely it is for anyone to actually
> sift through and review your patches after you've spammed them by
> posting so many at one time?

I honestly don't expect people to be reading the whole thing at once.
But, I do hope that people can take a look at their individual bits that
are touched.

> A second infraction and I will have no choice but to block you at the
> SMTP level at vger.kernel.org so please do not do it again.

I know these patches are certainly not at the level of importance as,
say the pata or -stable updates, but they're certainly not of
unprecedented scale.  I've seen a number of patchbombs of this size
recently.

I hope Andrew pulls this set into -mm so this doesn't even come up
again.  But, if it does, can you make some suggestions on how to be more
kind to vger in the process?

-- Dave

