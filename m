Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab2KOVZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:25:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48394 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2KOVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:25:32 -0500
Date: Thu, 15 Nov 2012 16:08:14 -0500 (EST)
Message-Id: <20121115.160814.435634108503717660.davem@davemloft.net>
To: gustavo@padovan.org
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ulisses@profusion.mobi, marcel@holtmann.org,
        vinicius.gomes@openbossa.org, linville@tuxdriver.com,
        johan.hedberg@gmail.com
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121115210437.GA3358@joana>
References: <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
	<20121115.151341.694285418420091290.davem@davemloft.net>
	<20121115210437.GA3358@joana>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo Padovan <gustavo@padovan.org>
Date: Thu, 15 Nov 2012 19:04:37 -0200

> We will no put our stuff in netdev.

You very much better post your work there for review purposes or else
I'm not even going to consider pulling from your tree, and I'm going
to tell John to not pull your GIT tree in either.

