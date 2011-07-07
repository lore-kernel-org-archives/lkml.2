Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1GGSj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:39:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab1GGSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:39:57 -0400
Date: Thu, 07 Jul 2011 11:39:39 -0700 (PDT)
Message-Id: <20110707.113939.1108700369645229770.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: mst@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8 2/4 net-next] skbuff: skb supports zero-copy buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1310063545.10209.30.camel@localhost.localdomain>
References: <1309990932.10209.19.camel@localhost.localdomain>
	<20110707.040149.441417258943576903.davem@davemloft.net>
	<1310063545.10209.30.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 11:39:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Thu, 07 Jul 2011 11:32:25 -0700

> You are right, will fix it.

You don't need to, I fixed it when I committed the patch
to net-next-2.6
