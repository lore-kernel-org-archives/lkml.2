Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2HIGVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:21:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2HIGU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:20:59 -0400
Date: Wed, 08 Aug 2012 23:20:58 -0700 (PDT)
Message-Id: <20120808.232058.1128673474849407813.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.ariyasu@hp.com,
        jan.ariyasu@gmail.com, nhorman@tuxdriver.com, tgraf@infradead.org,
        xi.wang@gmail.com
Subject: Re: [PATCH net-next 0/7] sctp: network namespace support Part 2:
 per net tunables
From: David Miller <davem@davemloft.net>
In-Reply-To: <87ipcud3ld.fsf_-_@xmission.com>
References: <87mx27rig7.fsf@xmission.com>
	<87zk67q31q.fsf_-_@xmission.com>
	<87ipcud3ld.fsf_-_@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 07 Aug 2012 10:17:02 -0700

> Since I am motivated to get things done, and since there has been much
> grumbling about my patches not implementing tunables, I have added
> tunable support on top of my last patchset.
> 
> I have performed basic testing on the these patches and nothing
> appears amis.
> 
> The sm statemachine is a major tease as it has all of these association
> and endpoint pointers in the common set of function parameters that turn
> out to be NULL at the most inconvinient times.  So I added to the common
> parameter list a struct net pointer, that is never NULL. 

I like Eric's patch set and I'd like to apply it to net-next.

Vlad?
