Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1EDXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:49:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:47060 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab1EDXty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,317,1301900400"; 
   d="scan'208";a="688333859"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Kleikamp <dkleikamp@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org>
	<alpine.LFD.2.02.1105050023070.3005@ionos>
	<20110504230349.GC2925@one.firstfloor.org>
	<alpine.LFD.2.02.1105050110440.3005@ionos>
	<20110504234241.GD2925@one.firstfloor.org>
	<alpine.LFD.2.02.1105050144030.3005@ionos>
Date: Wed, 04 May 2011 16:49:42 -0700
In-Reply-To: <alpine.LFD.2.02.1105050144030.3005@ionos> (Thomas Gleixner's
	message of "Thu, 5 May 2011 01:47:44 +0200 (CEST)")
Message-ID: <m2liymyqjt.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Thu, 5 May 2011, Andi Kleen wrote:
>> On Thu, May 05, 2011 at 01:29:49AM +0200, Thomas Gleixner wrote:
>> > That makes sense, but merging the timeouts race free will be a real
>> > PITA.
>> 
>> For this case one could actually use a spinlock between the siblings.
>> That shouldn't be a problem as long as it's not a global spinlock.
>
> Care to give it a try ?

Ok, will try tomorrow.

>> Here's a new patch without the raw. Boots on my Westmere.
>
>> +	cpu = raw_smp_processor_id();
>
> Hmm. quilt refresh perhaps ? I know that feeling :)

The scp to copy the patch was too slow. Noticed it later and sent a new
one.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
