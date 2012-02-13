Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2BMFvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:51:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59199 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2BMFvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:51:09 -0500
Date: Mon, 13 Feb 2012 00:50:56 -0500 (EST)
Message-Id: <20120213.005056.2043302555069385577.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: isdn@linux-pingi.de, dkukawka@suse.de, jj@chaosbits.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN/hfcsusb: remove unused variable hfcsusb_rev
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328886068-22646-1-git-send-email-danny.kukawka@bisect.de>
References: <1328886068-22646-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 12 Feb 2012 21:50:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 10 Feb 2012 16:01:08 +0100

> Removed unused variable hfcsusb_rev (-Wunused-variable) and
> copied Revision info to file comment block above to keep the info.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
