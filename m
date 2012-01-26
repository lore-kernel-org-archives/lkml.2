Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2AZLFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:05:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65533 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZLFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120125.213802.119259327303074622.davem@davemloft.net>
References: <25353423.731327481250682.JavaMail.root@5-MeO-DMT.ynet.sk>
 <32686570.751327481334943.JavaMail.root@5-MeO-DMT.ynet.sk> <20120125.213802.119259327303074622.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 12:04:50 +0100
X-Google-Sender-Auth: IutDJoeKFc5Mpe8RlUUI-rub0hE
Message-ID: <CAGsizzLp11qzJGTYr+m49yi=2RyWTjkOzaT7d3ni0EfvPsKmHg@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] Source mode for macvlan interface
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 David Miller <davem@davemloft.net>:
> From: Stefan Gula <steweg@ynet.sk>
> Date: Wed, 25 Jan 2012 09:48:54 +0100 (CET)
>
>> +             if (vlan->mode == MACVLAN_MODE_SOURCE &&
>> +                     vlan->mode != nla_get_u32(data[IFLA_MACVLAN_MODE]))
>  ...
>> +     if (data && data[IFLA_MACVLAN_MACADDR_MODE] &&
>> +             data[IFLA_MACVLAN_MACADDR]) {
>  ...
>> +                             return macvlan_hash_add_sources(vlan,
>> +                                     nla_data(data[IFLA_MACVLAN_MACADDR]));
>  ...
>> +                     hlist_for_each_entry_rcu(list, n,
>> +                             &vlan->port->vlan_source_hash[i], hlist) {
>  ...
>> +                     hlist_for_each_entry_rcu(list, n,
>> +                             &vlan->port->vlan_source_hash[i], hlist) {
>
> Line things up on subsequent lines to the column right after the
> openning parenthesis on the previous line.
>
> If things are indented too deeply, you need to write helper functions.
Just to be sure, how many "\t" symbols are ok in patches? I want to
avoid similar thing in future.
