Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab1LWVxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:53:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1LWVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:08 -0500
Date: Fri, 23 Dec 2011 16:53:00 -0500 (EST)
Message-Id: <20111223.165300.2261669987917250996.davem@davemloft.net>
To: allan@asix.com.tw
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, freddy@asix.com.tw,
        grundler@chromium.org, elubarsky@gmail.com, louis@asix.com.tw
Subject: Re: [PATCH v2] drivers/net/usb/asix: fixed asix_get_wol reported
 wrong wol status issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <005001ccc13d$8c9850e0$a5c8f2a0$@com.tw>
References: <005001ccc13d$8c9850e0$a5c8f2a0$@com.tw>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 23 Dec 2011 13:53:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "allan" <allan@asix.com.tw>
Date: Fri, 23 Dec 2011 14:38:51 +0800

> Fixed the asix_get_wol() routine reported wrong wol status issue. 
> 
> Signed-off-by: Allan Chou <allan@asix.com.tw>
> Tested-by: Eugene <elubarsky@gmail.com>; Allan Chou <allan@asix.com.tw>

Applied.
