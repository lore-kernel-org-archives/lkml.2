Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2GTSWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:22:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54519 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2GTSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:22:15 -0400
Date: Fri, 20 Jul 2012 11:22:13 -0700 (PDT)
Message-Id: <20120720.112213.1696121870344034064.davem@davemloft.net>
To: chenhui.zhao@freescale.com
Cc: netdev@vger.kernel.org, scottwood@freescale.com,
        linux-kernel@vger.kernel.org, leoli@freescale.com
Subject: Re: [PATCH] gianfar: add support for wake-on-packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342788723-27703-1-git-send-email-chenhui.zhao@freescale.com>
References: <1342788723-27703-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Chenhui <chenhui.zhao@freescale.com>
Date: Fri, 20 Jul 2012 20:52:03 +0800

> Note: The local ip/mac address is the ethernet primary IP/MAC address of
> the station. Do not support multiple IP/MAC addresses.

I'm not applying this.

There is no such concept of "primary IP address" for interfaces,
just picking the first interface address you find is completel
bogus.

Someone might add 100 IP addresses, then the one that's "primary",
and vice versa.
