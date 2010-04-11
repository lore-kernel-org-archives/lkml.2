Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab0DKJVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 05:21:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57799
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0DKJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 05:21:15 -0400
Date: Sun, 11 Apr 2010 02:21:18 -0700 (PDT)
Message-Id: <20100411.022118.35346455.davem@davemloft.net>
To: yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: ssh server etc doesn't work anymore with net-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <r2v86802c441004110217u15591f95ydd1e8e1466a36dc2@mail.gmail.com>
References: <r2v86802c441004110217u15591f95ydd1e8e1466a36dc2@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Sun, 11 Apr 2010 02:17:09 -0700

> caused by:
> 
> commit 2626419ad5be1a054d350786b684b41d23de1538
> Author: David S. Miller <davem@davemloft.net>
> Date:   Thu Apr 8 11:32:30 2010 -0700
> 
>     tcp: Set CHECKSUM_UNNECESSARY in tcp_init_nondata_skb
> 
> it will make sshd server, telnet server and vnc server doesn't respond
> connecting request anymore.

I'll either fix or revert this, thanks for reporting.
