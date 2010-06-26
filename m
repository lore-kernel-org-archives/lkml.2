Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0FZEfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 00:35:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51871
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab0FZEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 00:35:20 -0400
Date: Fri, 25 Jun 2010 21:35:33 -0700 (PDT)
Message-Id: <20100625.213533.124076851.davem@davemloft.net>
To: joe@perches.com
Cc: robert.olsson@its.uu.se, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/core/pktgen.c: Use pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1277159354.1775.212.camel@Joe-Laptop.home>
References: <1277159354.1775.212.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 21 Jun 2010 15:29:14 -0700

> Add pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove "pktgen: " from formats
> Convert printks to pr_<level>
> Added func_enter() for debugging
> Moved version to end of string at module_init
> Coalesced long formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
