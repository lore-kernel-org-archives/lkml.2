Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab2IUCGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:06:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41355 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2IUCGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:06:14 -0400
Date: Thu, 20 Sep 2012 22:06:12 -0400 (EDT)
Message-Id: <20120920.220612.2006365556684233063.davem@davemloft.net>
To: joe@perches.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net1080: Neaten netdev_dbg use
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348186223.2134.1.camel@joe2Laptop>
References: <20120919194614.GA17585@kroah.com>
	<20120920.175335.1128494030737237412.davem@davemloft.net>
	<1348186223.2134.1.camel@joe2Laptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 20 Sep 2012 17:10:23 -0700

> Remove unnecessary temporary variable and #ifdef DEBUG block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
