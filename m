Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2E2XSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:18:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2E2XSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:18:15 -0400
Date: Tue, 29 May 2012 19:18:10 -0400 (EDT)
Message-Id: <20120529.191810.2141710455829509698.davem@davemloft.net>
To: devendra.aaru@gmail.com
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls
 (after pci_enable_device) fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338333250-11974-1-git-send-email-devendra.aaru@gmail.com>
References: <1338333250-11974-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 16:18:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please number your patches so that there is no ambguity as to what
order the patches should be applied.

That is especially important for patches like these two which make
changes in the same areas of code.
