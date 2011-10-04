Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab1JDU0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:26:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55865 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab1JDU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:26:09 -0400
Date: Tue, 04 Oct 2011 16:25:46 -0400 (EDT)
Message-Id: <20111004.162546.1812071808303878499.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Subject: Re: [PATCH 1/3] NET: fix phy init for AX88772 USB ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317758118-24052-1-git-send-email-grundler@chromium.org>
References: <1317758118-24052-1-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 04 Oct 2011 13:26:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Tue,  4 Oct 2011 12:55:16 -0700

> Fix phy initialization for AX88772 (USB 2.0 100BT). Failure was
> occasionally DHCP wouldn't work after reboot or suspend/resume cycle.
> 
> Remove MONITOR_MODE. In this mode, Received packets are not buffered when
> the remote wakeup is enabled.
> 
> Signed-off-by: "Freddy Xin" <freddy@asix.com.tw>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> Acked-by: Olof Johansson <olofj@chromium.org>

Applied to net-next-2.6
