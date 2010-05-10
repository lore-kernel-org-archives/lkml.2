Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0EJQ2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:28:00 -0400
Received: from stinky.trash.net ([213.144.137.162]:49606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab0EJQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:27:57 -0400
Message-ID: <4BE8340B.901@trash.net>
Date: Mon, 10 May 2010 18:27:55 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: mmotm 2010-04-28 - RCU whinges
References: <1272865436.2173.182.camel@edumazet-laptop>	<20100502.225509.233880079.davem@davemloft.net>	<4BE8290A.2080707@trash.net> <20100510.091257.51273494.davem@davemloft.net>
In-Reply-To: <20100510.091257.51273494.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 10 May 2010 17:40:58 +0200
> 
>> I queued this patch in nf-next, the only reason why I haven't
>> submitted it yet is that I was unable to get git to cleanly export
>> only the proper set of patches meant for -next due to a few merges,
>> it insists on including 5 patches already merged upstream. If you
>> don't mind ignoring the first 5 patches in the series, I'll send a
>> pull request tonight.
> 
> Something like "git format-patch origin" doesn't avoid those upstream
> commits?  Weird...

Yeah, it seems to have something to do with me merging the nf-2.6.git
tree a few weeks ago since it had patches queued that were too late
for 2.6.34. Even the --ignore-if-in-upstream option doesn't help.

> Another trick is to specify a commit range using triple-dot "..."
> notation, such as "origin...master"

Thanks, I'll give it another try, the alternative is manually
renumbering the entire patchset.
