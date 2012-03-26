Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2CZXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:14:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35754 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2CZXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:14:49 -0400
Date: Mon, 26 Mar 2012 19:12:37 -0400 (EDT)
Message-Id: <20120326.191237.2192763107267474232.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: haiyangz@microsoft.com, netdev@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120326231017.GA30684@kroah.com>
References: <1332800304-5060-1-git-send-email-haiyangz@microsoft.com>
	<1332800304-5060-2-git-send-email-haiyangz@microsoft.com>
	<20120326231017.GA30684@kroah.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 16:12:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 26 Mar 2012 16:10:17 -0700

> David, please do NOT apply this as-is.

BTW, ethtool had controls exactly for stuff like this.
