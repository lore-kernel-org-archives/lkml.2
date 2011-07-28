Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1G1Fkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:40:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42858 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1G1Fkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:40:32 -0400
Date: Wed, 27 Jul 2011 22:40:29 -0700 (PDT)
Message-Id: <20110727.224029.619127041796367339.davem@davemloft.net>
To: marek.vasut@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/2] ASIX: Use only 11 bits of header for data size
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311734687-23551-2-git-send-email-marek.vasut@gmail.com>
References: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com>
	<1311734687-23551-2-git-send-email-marek.vasut@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 27 Jul 2011 22:40:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marek.vasut@gmail.com>
Date: Wed, 27 Jul 2011 04:44:47 +0200

> The AX88772B uses only 11 bits of the header for the actual size. The other bits
> are used for something else. This causes dmesg full of messages:
> 
> 	asix_rx_fixup() Bad Header Length
> 
> This patch trims the check to only 11 bits. I believe on older chips, the
> remaining 5 top bits are unused.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Applied.
