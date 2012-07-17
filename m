Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2GQGBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:01:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2GQGBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:01:06 -0400
Date: Mon, 16 Jul 2012 23:01:05 -0700 (PDT)
Message-Id: <20120716.230105.2069123905936956283.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Subject: Re: [PATCH v4] net: cgroup: fix access the unallocated memory in
 netprio cgroup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120712105611.GA7055@hmsreliant.think-freely.org>
References: <1342079415-9631-1-git-send-email-gaofeng@cn.fujitsu.com>
	<20120712105611.GA7055@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 12 Jul 2012 06:56:11 -0400

> On Thu, Jul 12, 2012 at 03:50:15PM +0800, Gao feng wrote:
>> there are some out of bound accesses in netprio cgroup.
 ...
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 

Applied to 'net', thanks.
