Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0KHVnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:43:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57766
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704Ab0KHVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:43:53 -0500
Date: Mon, 08 Nov 2010 13:44:17 -0800 (PST)
Message-Id: <20101108.134417.35041051.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: eric.dumazet@gmail.com, alban.crequy@collabora.co.uk,
        shemminger@vyatta.com, gorcunov@openvz.org, adobriyan@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pauli.nieminen@collabora.co.uk, rweikusat@mssgmbh.com
Subject: Re: [PATCH] af_unix: unix_write_space() use keyed wakeups
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1010300759580.9195@localhost6.localdomain6>
References: <1288380431.2680.3.camel@edumazet-laptop>
	<1288421084.2680.717.camel@edumazet-laptop>
	<alpine.DEB.2.00.1010300759580.9195@localhost6.localdomain6>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Sat, 30 Oct 2010 08:03:15 -0700 (PDT)

> On Sat, 30 Oct 2010, Eric Dumazet wrote:
> 
>> This patch is a specialization of commit 37e5540b3c9d (epoll keyed
>> wakeups: make sockets use keyed wakeups).
> 
> Whoops, I must have missed AF_UNIX :)
> Looks good to me.

Applied.
