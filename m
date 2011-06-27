Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1F0WzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:55:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1F0Wye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:54:34 -0400
Date: Mon, 27 Jun 2011 15:54:26 -0700 (PDT)
Message-Id: <20110627.155426.51839633424542723.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: mst@redhat.com, eric.dumazet@gmail.com, avi@redhat.com, arnd@arndb.de,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 2/4 net-next] skbuff: Add userspace zero-copy
 buffers in skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309189510.21764.1.camel@localhost.localdomain>
References: <1306610588.5180.87.camel@localhost.localdomain>
	<1309189510.21764.1.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Jun 2011 15:54:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Mon, 27 Jun 2011 08:45:10 -0700

> To support skb zero-copy, a pointer is needed to add to skb share info.
> Do you agree with this approach? If not, do you have any other
> suggestions?

I really can't form an opinion unless I am shown the complete
implementation, what this give us in return, what the impact is, etc.
