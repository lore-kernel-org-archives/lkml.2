Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2JKTUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:20:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2JKTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:20:03 -0400
Date: Thu, 11 Oct 2012 15:20:00 -0400 (EDT)
Message-Id: <20121011.152000.1869700919732028911.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: andi@lisas.de, gregkh@linuxfoundation.org, lkml20120218@newton.leun.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcs7830: Fix link state detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201210111233.28652.linux@rainbow-software.org>
References: <201210111233.28652.linux@rainbow-software.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 11 Oct 2012 12:33:28 +0200

> The device had an undocumented "feature": it can provide a sequence of
> spurious link-down status data even if the link is up all the time.
> A sequence of 10 was seen so update the link state only after the device
> reports the same link state 20 times.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Reported-by: Michael Leun <lkml20120218@newton.leun.net>
> Tested-by: Michael Leun <lkml20120218@newton.leun.net>

You've been given feedback on this patch, and also it doesn't apply
cleanly.  Perhaps it was corrupted by your email client.
