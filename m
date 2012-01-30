Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2A3UWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:22:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41585 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab2A3UWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:22:35 -0500
Date: Mon, 30 Jan 2012 15:22:27 -0500 (EST)
Message-Id: <20120130.152227.271855483278409371.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Deinline __nlmsg_put and genlmsg_put. -7k code on
 i386 defconfig.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327952257-20623-1-git-send-email-vda.linux@googlemail.com>
References: <1327952257-20623-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Jan 2012 12:22:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 30 Jan 2012 20:37:37 +0100

>    text	   data	    bss	    dec	    hex	filename
> 8455963	 532732	1810804	10799499 a4c98b	vmlinux.o.before
> 8448899	 532732	1810804	10792435 a4adf3	vmlinux.o
> 
> This change also removes commented-out copy of __nlmsg_put
> which was last touched in 2005 with "Enable once all users
> have been converted" comment on top.
> 
> Changes in v2: rediffed against net-next.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Applied, thanks.
