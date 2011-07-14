Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1GNDrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:47:09 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51388 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab1GNDrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:47:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArIDAHJkHk55LCkBgWdsb2JhbABTp04VAQEWJiXKZQ6FTV8Eo0Y
Date: Thu, 14 Jul 2011 13:47:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: chris@chris-wilson.co.uk, keithp@keithp.com, linux-kernel@vger.kernel.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant
 shrink any objects
Message-ID: <20110714034701.GA31294@dastard>
References: <4E0444CA.3080407@jp.fujitsu.com>
 <yuny60kt1nx.fsf@aiko.keithp.com>
 <1309424153_44559@CP5-2952>
 <4E1C15B2.9020800@jp.fujitsu.com>
 <d08817$ot4e1@azsmga001.ch.intel.com>
 <4E1CE48C.2070402@jp.fujitsu.com>
 <d08817$pb86v@azsmga001.ch.intel.com>
 <4E1D550A.80301@jp.fujitsu.com>
 <20110713104236.GS23038@dastard>
 <4E1E58E8.6040200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1E58E8.6040200@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 11:48:08AM +0900, KOSAKI Motohiro wrote:
> >> If you are thinking the shrinker protocol is too complicated, doc update
> >> patch is really welcome.
> > 
> > Slab shrinkers have a nasty, crappy interface and the shrink_slab()
> > code is full of bugs.  Rather that telling people to "update the
> > documentation" because it's too complex, how about we fix the
> > interface and the bugs?
> 
> If you can take your time for that, I don't hesitate to help you. ;)

Its on my list of things to do if nobody else steps before I get
there ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
