Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2IDTNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:13:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2IDTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:13:36 -0400
Date: Tue, 04 Sep 2012 15:13:06 -0400 (EDT)
Message-Id: <20120904.151306.1766477429185359707.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i825xx: fix paging fault on znet_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120902072546.GA20290@localhost>
References: <20120902072546.GA20290@localhost>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>
Date: Sun, 2 Sep 2012 15:25:46 +0800

> In znet_probe(), strncmp() may access beyond 0x100000 and
> trigger the below oops in kvm.  Fix it by limiting the loop
> under 0x100000-8. I suspect the limit could be further decreased
> to 0x100000-sizeof(struct netidblk), however no datasheet at hand..
 ...
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

This also makes the code actually match the description in the comment
above the loop :-)

Applied, thanks.
