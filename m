Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1KNFum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:50:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52870 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1KNFul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:50:41 -0500
Date: Mon, 14 Nov 2011 00:49:29 -0500 (EST)
Message-Id: <20111114.004929.384609475492837593.davem@davemloft.net>
To: prox@prolixium.com
Cc: oliver@neukum.name, gregkh@suse.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] net/usb: Misc. fixes for the LG-VL600 LTE USB
 modem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320875290-29407-1-git-send-email-prox@prolixium.com>
References: <1320875290-29407-1-git-send-email-prox@prolixium.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:49:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Kamichoff <prox@prolixium.com>
Date: Wed,  9 Nov 2011 16:48:10 -0500

> Add checking for valid magic values (needed for stability in the event
> corrupted packets are received) and remove some other unneeded checks.
> Also, fix flagging device as WWAN (Bugzilla bug #39952).
> 
> Signed-off-by: Mark Kamichoff <prox@prolixium.com>

Applied, thanks Mark.
