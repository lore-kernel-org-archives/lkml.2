Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1BREkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:40:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53234
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218Ab1BREkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:40:01 -0500
Date: Thu, 17 Feb 2011 20:40:36 -0800 (PST)
Message-Id: <20110217.204036.226788819.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com, mingo@elte.hu, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        opurdila@ixiacom.com
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=kEEip7UjtLqvo0Hpz8uwjVdx334hYnPsoNXis@mail.gmail.com>
References: <m1sjvm822m.fsf@fess.ebiederm.org>
	<AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	<AANLkTi=kEEip7UjtLqvo0Hpz8uwjVdx334hYnPsoNXis@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 20:38:09 -0800

> On Thu, Feb 17, 2011 at 8:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> The patch from Eric Dumazet (which adds a few more cases to my patch
>> and hopefully catches them all) almost certainly fixes this rather
>> nasty memory corruption.
> 
> Oh, but you weren't cc'd on that part of the thread, since the thread
> got started from Michal Hocko's similar trouble. So you may have never
> even noticed that patch, or my "improved LIST_DEBUG" patch in the same
> thread)

I looked at Eric's (and your) patch before I wrote my reply :-)
