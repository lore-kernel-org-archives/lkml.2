Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0KVWTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:19:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43590
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab0KVWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:19:13 -0500
Date: Mon, 22 Nov 2010 14:19:39 -0800 (PST)
Message-Id: <20101122.141939.226774888.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
        libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH 00/62] drivers/net: Use static const
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290463846.27683.36.camel@Joe-Laptop>
References: <cover.1290305773.git.joe@perches.com>
	<20101120.205059.193725921.davem@davemloft.net>
	<1290463846.27683.36.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Nov 2010 14:10:46 -0800

> btw: it doesn't seem that, other than John Linville for wireless,
> you currently pull from many (any?) other people.  Do let me know
> if you'd consider pulling these sorts of changes from me.

Expand your horizon beyond drivers/net/ and into places like net/
and you'll see I also pull from people like Patrick McHardy, for
example.
