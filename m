Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2BFPPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:15:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2BFPPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:15:23 -0500
Date: Mon, 06 Feb 2012 10:15:17 -0500 (EST)
Message-Id: <20120206.101517.1598607878740481170.davem@davemloft.net>
To: steweg@ynet.sk
Cc: gregory.v.rose@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
References: <20120203.192933.510206531351047222.davem@davemloft.net>
	<C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
	<CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 07:15:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Mon, 6 Feb 2012 09:53:28 +0100

> If I try to request for it, it will eventually fail with a lot of
> records even with filtering...

Then the user can loop increasing the buffer size until the netlink
request succeeds.

It is not a problem.
