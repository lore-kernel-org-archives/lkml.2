Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0I3C1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:27:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50467
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab0I3C1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:27:16 -0400
Date: Wed, 29 Sep 2010 19:27:37 -0700 (PDT)
Message-Id: <20100929.192737.242138187.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bharrosh@panasas.com, akpm@linux-foundation.org, julia@diku.dk,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2:
 arch/um/drivers: remove duplicate structure field initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=aqtzLskpTeZkQwEGRg9jb=NJ8UcQG=vkdc20z@mail.gmail.com>
References: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
	<4CA2FBBB.3040004@panasas.com>
	<AANLkTi=aqtzLskpTeZkQwEGRg9jb=NJ8UcQG=vkdc20z@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Sep 2010 08:01:07 -0700

> On Wed, Sep 29, 2010 at 1:41 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> With this I'm now back to my usual: boots fine but half of the times
>> not halting. But I think that's a Fedora12 problem with interaction
>> with uml. (Which I do not have time to investigate)
> 
> So that "half of the time not halting" happened with the revert too?
> If so, we should just do the fix. Thanks for testing.

Linus, I've queued up your fix into my tree.
