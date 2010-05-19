Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0EST2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:28:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52417
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab0EST2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:28:43 -0400
Date: Wed, 19 May 2010 12:28:52 -0700 (PDT)
Message-Id: <20100519.122852.77359021.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274267582.2763.24.camel@localhost>
References: <20100518.233752.256882583.davem@davemloft.net>
	<1274267582.2763.24.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 19 May 2010 12:13:02 +0100

> On Tue, 2010-05-18 at 23:37 -0700, David Miller wrote:
> [...]
>> Some other things that stand out:
>> 
>> 1) Allow the administrator to reserve port ranges, such that the
>>    kernel bind allocation scheme won't use them.  From Amerigo Wang.
>> 
>> 2) ipv6 address et al. handling converted to use generic kernel lists.
>>    From Stephem Hemminger.
>> 
>> 3) PHY module autoloading support from David Howells
> [...]
> 
> For the record, that was actually David Woodhouse.

Indeed, already apologized to him in private email.   My bad :-/
