Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab1BRTzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:55:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885Ab1BRTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:55:45 -0500
Date: Fri, 18 Feb 2011 11:56:21 -0800 (PST)
Message-Id: <20110218.115621.226793798.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mhocko@suse.cz, ebiederm@xmission.com, mingo@elte.hu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
References: <20110218122938.GB26779@tiehlicka.suse.cz>
	<20110218162623.GD4862@tiehlicka.suse.cz>
	<AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Feb 2011 08:39:02 -0800

> On Fri, Feb 18, 2011 at 8:26 AM, Michal Hocko <mhocko@suse.cz> wrote:
>>> Now, I will try with the 2 patches patches in this thread. I will also
>>> turn on DEBUG_LIST and DEBUG_PAGEALLOC.
>>
>> I am not able to reproduce with those 2 patches applied.
> 
> Thanks for verifying. Davem/EricD - you can add Michal's tested-by to
> the patches too.

Yep, I added Eric B.'s too, thanks!
