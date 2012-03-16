Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032732Ab2CPKmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:42:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030833Ab2CPKmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:42:51 -0400
Message-ID: <1331894554.18960.234.camel@twins>
Subject: Re: cpu_active vs pcrypt & padata
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: steffen.klassert@secunet.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Date: Fri, 16 Mar 2012 11:42:34 +0100
In-Reply-To: <20120316.033204.2200537098677808280.davem@davemloft.net>
References: <1331892788.18960.227.camel@twins>
	 <20120316.031644.577275447313181686.davem@davemloft.net>
	 <1331893215.18960.228.camel@twins>
	 <20120316.033204.2200537098677808280.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 03:32 -0700, David Miller wrote:

> Beats me, but just because there's only one user doesn't mean it belongs
> tucked away in that one user's subsystem.

Sure, but I was mostly wondering wth it was, the file doesn't really
explain itself. 

Also, most times when introducing generic functionality people try to
collect all interested parties and make something that works for
everybody.

I know for a fact that btrfs does the fan out and regroup thing for
block checksumming etc.. Does Chris even know it exists? If he does why
isn't brtfs using it? If its unsuitable, why wasn't it fixed.

I'm not saying its crap or anything -- I haven't looked at it at all,
beyond my grep for cpu_active -- I'm just wondering, and so far it looks
like there's something weird.
