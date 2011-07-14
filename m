Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1GNQF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:05:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1GNQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:05:26 -0400
Date: Thu, 14 Jul 2011 09:03:25 -0700 (PDT)
Message-Id: <20110714.090325.1514544531042623590.davem@davemloft.net>
To: viliam.mateicka@gmail.com
Cc: mirq-linux@rere.qmqm.pl, steve.glendinning@smsc.com, rabin@rab.in,
        decot@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc95xx: add missing .reset_resume hook and reset card
From: David Miller <davem@davemloft.net>
In-Reply-To: <1310644306-16180-1-git-send-email-viliam.mateicka@gmail.com>
References: <1310644306-16180-1-git-send-email-viliam.mateicka@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 14 Jul 2011 09:03:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viliam Mateicka <viliam.mateicka@gmail.com>
Date: Thu, 14 Jul 2011 13:51:46 +0200

> This patch fixes the undefined behaviour (random MAC, interface goes down) of smsc95xx driver after resume from suspend.
> Calling smsc95xx_reset() is needed to properly set hw registers of card and bring interface up to defined state.
> 
> Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>

Please submit networking patches to netdev@vger.kernel.org so that
it can be tracked properly.
