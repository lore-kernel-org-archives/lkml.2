Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0IGBkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:40:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57948
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034Ab0IGBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:40:21 -0400
Date: Mon, 06 Sep 2010 18:40:38 -0700 (PDT)
Message-Id: <20100906.184038.45882158.davem@davemloft.net>
To: joe@perches.com
Cc: sjur.brandeland@stericsson.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/caifcaif_dev.c: Use netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283760489.23280.77.camel@Joe-Laptop>
References: <1283758271.23280.73.camel@Joe-Laptop>
	<1283760489.23280.77.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 06 Sep 2010 01:08:09 -0700

> Convert pr_<level>("%s" ..., (struct netdev *)->name ...)
> to netdev_<level>((struct netdev *), ...)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
