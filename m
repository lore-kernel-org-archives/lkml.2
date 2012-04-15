Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2DOEVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 00:21:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33910 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2DOEVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 00:21:41 -0400
Date: Sun, 15 Apr 2012 00:21:25 -0400 (EDT)
Message-Id: <20120415.002125.1245643666941498950.davem@davemloft.net>
To: peterhuewe@gmx.de
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] isdn/hysdn: Convert to kstrtoul_from_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334446979-1177-1-git-send-email-peterhuewe@gmx.de>
References: <1334446979-1177-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Apr 2012 21:21:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Sun, 15 Apr 2012 01:42:59 +0200

> This patch replaces the code for getting an number from a
> userspace buffer by a simple call to kstroul_from_user.
> This makes it easier to read and less error prone.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied to net-next, thanks a lot.
