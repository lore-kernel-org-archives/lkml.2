Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1HWWiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:38:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52983 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1HWWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:38:20 -0400
Date: Tue, 23 Aug 2011 15:36:22 -0700 (PDT)
Message-Id: <20110823.153622.1166242430280142268.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: remove "Switched to NOHz mode" debugging messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
References: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 23 Aug 2011 15:37:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 23 Aug 2011 13:20:46 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> When performing cpu hotplug tests the kernel printk log buffer gets flooded
> with pointless "Switched to NOHz mode..." messages. Especially when afterwards
> analyzing a dump this might have removed more interesting stuff out of the
> buffer.
> Assuming that switching to NOHz mode simply works just remove the printk.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

These drive me nuts during bootup on my 128+ cpu machines :-/  Thanks
for taking care of this.

Acked-by: David S. Miller <davem@davemloft.net>
