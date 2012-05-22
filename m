Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440Ab2EVUxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:53:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2EVUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:53:06 -0400
Date: Tue, 22 May 2012 16:50:47 -0400 (EDT)
Message-Id: <20120522.165047.1026251950879022093.davem@davemloft.net>
To: marmarek@invisiblethingslab.com
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xen.org,
        virtualization@lists.linux-foundation.org, konrad.wilk@oracle.com,
        jeremy@goop.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESENT] xen: do not disable netfront in dom0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120522204742.29E8A626@duch.mimuw.edu.pl>
References: <20120522194319.GA2691@phenom.dumpdata.com>
	<20120522204742.29E8A626@duch.mimuw.edu.pl>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 13:50:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Marczykowski <marmarek@invisiblethingslab.com>
Date: Sun, 20 May 2012 13:45:10 +0200

> Netfront driver can be also useful in dom0, eg when all NICs are assigned to
> some domU (aka driver domain). Then using netback in domU and netfront in dom0
> is the only way to get network access in dom0.
> 
> Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Applied, thanks.
