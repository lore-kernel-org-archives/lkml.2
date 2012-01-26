Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2AZScL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:32:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33327 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2AZScJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:32:09 -0500
Date: Thu, 26 Jan 2012 13:31:03 -0500 (EST)
Message-Id: <20120126.133103.538010558337810138.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] Source mode for macvlan
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzLp11qzJGTYr+m49yi=2RyWTjkOzaT7d3ni0EfvPsKmHg@mail.gmail.com>
References: <32686570.751327481334943.JavaMail.root@5-MeO-DMT.ynet.sk>
	<20120125.213802.119259327303074622.davem@davemloft.net>
	<CAGsizzLp11qzJGTYr+m49yi=2RyWTjkOzaT7d3ni0EfvPsKmHg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 10:31:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 12:04:50 +0100

> 2012/1/26 David Miller <davem@davemloft.net>:
>> From: Stefan Gula <steweg@ynet.sk>
>> Date: Wed, 25 Jan 2012 09:48:54 +0100 (CET)
>>
>>> +             if (vlan->mode == MACVLAN_MODE_SOURCE &&
>>> +                     vlan->mode != nla_get_u32(data[IFLA_MACVLAN_MODE]))
>>  ...
>>> +     if (data && data[IFLA_MACVLAN_MACADDR_MODE] &&
>>> +             data[IFLA_MACVLAN_MACADDR]) {
>>  ...
>>> +                             return macvlan_hash_add_sources(vlan,
>>> +                                     nla_data(data[IFLA_MACVLAN_MACADDR]));
>>  ...
>>> +                     hlist_for_each_entry_rcu(list, n,
>>> +                             &vlan->port->vlan_source_hash[i], hlist) {
>>  ...
>>> +                     hlist_for_each_entry_rcu(list, n,
>>> +                             &vlan->port->vlan_source_hash[i], hlist) {
>>
>> Line things up on subsequent lines to the column right after the
>> openning parenthesis on the previous line.
>>
>> If things are indented too deeply, you need to write helper functions.
> Just to be sure, how many "\t" symbols are ok in patches? I want to
> avoid similar thing in future.

Keep it not to far past 80 columns.
