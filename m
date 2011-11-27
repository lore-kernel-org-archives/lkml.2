Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1K0WI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:08:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47292 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1K0WI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:08:58 -0500
Date: Sun, 27 Nov 2011 17:08:43 -0500 (EST)
Message-Id: <20111127.170843.1218883428304355076.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/gigaset: report ISDN4Linux interface only once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111127-patch-gigaset-01.tilman@imap.cc>
References: <20111127-patch-gigaset-01.tilman@imap.cc>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 27 Nov 2011 14:08:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun, 27 Nov 2011 18:39:22 +0100

> Move the "ISDN4Linux interface" message from device registration,
> where it is emitted for each device, to driver registration, where
> it is emitted only once, for consistency with the CAPI variant.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied to net-next, thanks.
