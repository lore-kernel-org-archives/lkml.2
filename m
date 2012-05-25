Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2EYUrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:47:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50488 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2EYUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:47:05 -0400
Subject: Re: [PATCH] net: compute a more reasonable default ip6_rt_max_size
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
In-Reply-To: <1337976934-18065-1-git-send-email-asharma@fb.com>
References: <1337976934-18065-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 22:47:00 +0200
Message-ID: <1337978820.10135.1.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 13:15 -0700, Arun Sharma wrote:
> The algorithm is based on ipv4 and alloc_large_system_hash().
> 

Why is it needed at all ?

IPv4 has a route cache with potentially millions of entries, not IPv6.


