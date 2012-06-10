Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2FJFE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 01:04:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33101 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2FJFE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 01:04:27 -0400
Date: Sat, 09 Jun 2012 22:04:21 -0700 (PDT)
Message-Id: <20120609.220421.2043389435765629622.davem@davemloft.net>
To: wfg@linux.intel.com
Cc: netdev@vger.kernel.org, gaofeng@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inet: Initialize per-netns inetpeer roots in
 net/ipv{4,6}/route.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120610044934.GA10507@localhost>
References: <20120609.212147.1738198233131370927.davem@davemloft.net>
	<20120610044339.GA10436@localhost>
	<20120610044934.GA10507@localhost>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <wfg@linux.intel.com>
Date: Sun, 10 Jun 2012 12:49:34 +0800

> On Sun, Jun 10, 2012 at 12:43:39PM +0800, Fengguang Wu wrote:
>> On Sat, Jun 09, 2012 at 09:21:47PM -0700, David Miller wrote:
>> > From: Fengguang Wu <wfg@linux.intel.com>
>> > Date: Sun, 10 Jun 2012 11:16:34 +0800
>> > 
>> > > In long run, such build-fix patches can also be auto tested and
>> > > reported, somehow in this way. You just create a temporary branch
>> > 
>> > Sorry, no.
>> 
>> That's fine. Then how about including some text "fix build errors" or
>> "fix build warnings" or paste the original gcc error/warning messages,
>> somewhere in the changelog or subject?
>> 
>> That will also allow me recognize that it's a build fix commit and to
>> make it unconditionally report back any build results.
> 
> Or better, simply include a 
> 
>         Reported-by: Fengguang Wu <wfg@linux.intel.com>

Now that on the other hand I should have done and was an oversight.

But all the other crap, is absolutely unreasonable of you to ask of me.
