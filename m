Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0JaNmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 09:42:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723Ab0JaNmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 09:42:21 -0400
Date: Sun, 31 Oct 2010 06:42:45 -0700 (PDT)
Message-Id: <20101031.064245.35056660.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288516747.4050.10.camel@localhost>
References: <20101030.183257.70183832.davem@davemloft.net>
	<1288516747.4050.10.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 31 Oct 2010 10:19:07 +0100

> On Sat, 2010-10-30 at 18:32 -0700, David Miller wrote:
>> Last pull request before 2.6.37-rc1, I really wanted to get your
>> sendto/recvfrom patch in here as well as the RDS fixes.
>> 
>> I did a bunch of tests with the various I/O calls using different
>> lengths, like 10, (2^31 - 1), 2^31, 2^32, and larger on 64-bit and it
>> all seems to be doing the right thing at least with TCP and UDP.
> [...]
>> 7) RDS fixes from you and Andy Grover.
> [...]
> 
> Aren't the generic length limiting changes (8acfe46 and 253eacc) also
> supposed to cover the overflow issues with TIPC?  Or are those still
> unfixed?

Yes, the TIPC issues should be cured by those generic networking changes.
