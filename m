Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab0JXW2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:28:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57987
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933104Ab0JXW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:28:07 -0400
Date: Sun, 24 Oct 2010 15:28:30 -0700 (PDT)
Message-Id: <20101024.152830.102557040.davem@davemloft.net>
To: holt@sgi.com
Cc: w@1wt.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        vladislav.yasevich@hp.com, sri@us.ibm.com
Subject: Re: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101020120345.436404838@gulag1.americas.sgi.com>
References: <20101020120336.967805943@gulag1.americas.sgi.com>
	<20101020120345.436404838@gulag1.americas.sgi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Wed, 20 Oct 2010 07:03:37 -0500

> Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
> 
> On a 16TB x86_64 machine, sysctl_tcp_mem[2], sysctl_udp_mem[2], and
> sysctl_sctp_mem[2] can integer overflow.  Set limit such that they are
> maximized without overflowing.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>

I'll queue this up for -stable, thanks Robin!
