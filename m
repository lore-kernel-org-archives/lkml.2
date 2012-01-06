Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030613Ab2AFVO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:14:27 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:33723 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234Ab2AFVO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:14:26 -0500
To: Glauber Costa <glommer@parallels.com>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        Laurent Chavey <chavey@google.com>
Subject: Re: [PATCH] net: fix sock_clone reference mismatch with tcp memcontrol
Message-Id: <20120106211423.967A716F64A@chavey.mtv.corp.google.com>
Date: Fri,  6 Jan 2012 13:14:23 -0800 (PST)
From: chavey@google.com (Laurent Chavey)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sockets can also be created through sock_clone. Because it copies
> all data in the sock structure, it also copies the memcg-related pointer,
> and all should be fine. However, since we now use reference counts in
> socket creation, we are left with some sockets that have no reference
> counts. It matters when we destroy them, since it leads to a mismatch.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Greg Thelen <gthelen@google.com>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Laurent Chavey <chavey@google.com>
>
> ---

Tested-by: Laurent Chavey <chavey@google.com>
