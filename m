Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2DDWO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:14:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50388 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2DDWO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:14:27 -0400
Date: Wed, 04 Apr 2012 18:14:23 -0400 (EDT)
Message-Id: <20120404.181423.349006217600228558.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: cmetcalf@tilera.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] sky2: copy received packets on inefficient
 unaligned architecture
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404151027.047c183b@s6510.linuxnetplumber.net>
References: <20120404114253.5f84d4c8@s6510.linuxnetplumber.net>
	<4F7CC2AC.5040309@tilera.com>
	<20120404151027.047c183b@s6510.linuxnetplumber.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 15:14:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 4 Apr 2012 15:10:27 -0700

> Modified from original patch from Chris.
> 
> The sky2 driver has to have 8 byte alignment of receive buffer
> on some chip versions. On architectures which don't support efficient
> unaligned access this doesn't work very well. The solution is to
> just copy all received packets which is what the driver already
> does for small packets.
> 
> This allows the driver to be used on the Tilera TILEmpower-Gx, since
> the tile architecture doesn't currently handle kernel unaligned accesses,
> just userspace.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Applied.
