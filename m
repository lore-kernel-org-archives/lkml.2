Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0LHRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:09:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34022
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537Ab0LHRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:09:27 -0500
Date: Wed, 08 Dec 2010 09:09:54 -0800 (PST)
Message-Id: <20101208.090954.115924303.davem@davemloft.net>
To: kadlec@blackhole.kfki.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, torvalds@osdl.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 0/2] New jhash function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1291379941-31565-1-git-send-email-kadlec@blackhole.kfki.hu>
References: <201011271401.22773.rusty@rustcorp.com.au>
	<1291379941-31565-1-git-send-email-kadlec@blackhole.kfki.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Fri,  3 Dec 2010 13:38:59 +0100

> The current jhash.h implements the lookup2() hash function by Bob Jenkins. 
> However, lookup2() is outdated as Bob wrote a new hash function called 
> lookup3(). There is a longer comparison of those two and other hash
> functions at http://burtleburtle.net/bob/hash/doobs.html.
> 
> Please consider applying the following patches.

Patch #1 is already in the net-next-2.6 tree, and as long as there are
no major objections to the general crowd (including Rusty et al.) I am
happy to put patch #2 into my tree as well.

Rusty, does the current version of patch #2 look good to you?

Thanks!
