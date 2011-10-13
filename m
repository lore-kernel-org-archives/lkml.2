Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1JMUJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:09:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34555 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab1JMUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:09:14 -0400
Date: Thu, 13 Oct 2011 16:08:54 -0400 (EDT)
Message-Id: <20111013.160854.1765661520007592071.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E9744A6.5010101@parallels.com>
References: <1318511382-31051-1-git-send-email-glommer@parallels.com>
	<20111013.160031.605700447623532119.davem@davemloft.net>
	<4E9744A6.5010101@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 13:08:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 14 Oct 2011 00:05:58 +0400

> On 10/14/2011 12:00 AM, David Miller wrote:
>> That imposes a new non-trivial cost, in fast paths, even when people
>> do not use your feature.
> Well, there is a cost, but all past submissions included round trip
> benchmarks.
> In none of them I could see any significant slowdown.

Did you try millions of sockets doing all kinds of different accesses?

Did you check the nanosecond latency of operations over loopback so
that the real cost of you change can be isolated and thus measured
properly?
