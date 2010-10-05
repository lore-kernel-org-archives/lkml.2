Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0JEVuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:50:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58344
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab0JEVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:50:11 -0400
Date: Tue, 05 Oct 2010 14:50:32 -0700 (PDT)
Message-Id: <20101005.145032.25126909.davem@davemloft.net>
To: holt@sgi.com
Cc: w@1wt.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101002112419.248437367@gulag1.americas.sgi.com>
References: <20101002112405.951704198@gulag1.americas.sgi.com>
	<20101002112419.248437367@gulag1.americas.sgi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Sat, 02 Oct 2010 06:24:06 -0500

> Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
> 
> On a 16TB x86_64 machine, sysctl_tcp_mem[2], sysctl_udp_mem[2], and
> sysctl_sctp_mem[2] can integer overflow.  Set limit such that they are
> maximized without overflowing.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>

Robin please resubmit this with the SCTP bits included.
