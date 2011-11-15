Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1KOVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:41:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35032 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab1KOVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:41:58 -0500
Date: Tue, 15 Nov 2011 16:41:53 -0500 (EST)
Message-Id: <20111115.164153.1285351501002169756.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw, grundler@google.com
Subject: Re: [PATCH 3/5] net-next:asix: reduce AX88772 init time by about 2
 seconds
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321377163-26308-3-git-send-email-grundler@chromium.org>
References: <1321377163-26308-1-git-send-email-grundler@chromium.org>
	<1321377163-26308-3-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 Nov 2011 13:41:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Tue, 15 Nov 2011 09:12:41 -0800

> From: Grant Grundler <grundler@google.com>
> 
> ax88772_reset takes about 2 seconds and is called twice.
> Once from ax88772_bind() directly and again indirectly from usbnet_open().
> Reset the USB FW/Phy enough to blink the LEDs when inserted.
> 
> Signed-off-by: Allan Chou <allan@asix.com.tw>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Applied.
