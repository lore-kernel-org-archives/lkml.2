Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab2EYUpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:45:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42164 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2EYUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:45:30 -0400
Subject: Re: WARNING: at net/ipv4/tcp.c:1610 tcp_recvmsg+0xb1b/0xc70()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4FBFEACC.8040601@fastmail.fm>
References: <4FBFEACC.8040601@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 22:45:25 +0200
Message-ID: <1337978725.10135.0.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 21:25 +0100, Jack Stone wrote:
> Hi All,
> 
> The following warning keeps hitting me. I couldn't get the first one - it had already left dmesg hence the W taint.
> The C taint is from r8712u from staging.
> 
> I've seen it with 3.4.0-076444-g07acfc2 (recent Linus tree) and 3.4.0-rc3-00089-gc6f5c93.
> 
> I am going to attempt to bisect it now.

No need, update your tree.



