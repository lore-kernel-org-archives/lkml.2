Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab2JLR7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:59:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759988Ab2JLR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:59:38 -0400
Date: Fri, 12 Oct 2012 13:59:36 -0400 (EDT)
Message-Id: <20121012.135936.17533537590412761.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: andi@lisas.de, gregkh@linuxfoundation.org, lkml20120218@newton.leun.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mcs7830: Fix link state detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201210121051.42359.linux@rainbow-software.org>
References: <201210121051.42359.linux@rainbow-software.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 12 Oct 2012 10:51:41 +0200

> The device had an undocumented "feature": it can provide a sequence of
> spurious link-down status data even if the link is up all the time.
> A sequence of 10 was seen so update the link state only after the device
> reports the same link state 20 times.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Reported-by: Michael Leun <lkml20120218@newton.leun.net>
> Tested-by: Michael Leun <lkml20120218@newton.leun.net>

Applied.
