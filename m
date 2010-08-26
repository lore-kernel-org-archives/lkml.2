Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0HZVMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:12:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44453
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261Ab0HZVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:12:08 -0400
Date: Thu, 26 Aug 2010 14:12:24 -0700 (PDT)
Message-Id: <20100826.141224.229731596.davem@davemloft.net>
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net/sctp: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282692068.25208.11.camel@Joe-Laptop>
References: <1282692068.25208.11.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 Aug 2010 16:21:08 -0700

> Change SCTP_DEBUG_PRINTK and SCTP_DEBUG_PRINTK_IPADDR to
> use do { print } while (0) guards.
> Add SCTP_DEBUG_PRINTK_CONT to fix errors in log when
> lines were continued.
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Add a missing newline in "Failed bind hash alloc"
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
