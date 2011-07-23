Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1GWMgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 08:36:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1GWMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 08:36:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (arm-soc tree related)
Date: Sat, 23 Jul 2011 14:36:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
References: <20110722164204.15f3bfee0c3ab04adb80e611@canb.auug.org.au>
In-Reply-To: <20110722164204.15f3bfee0c3ab04adb80e611@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107231436.22389.arnd@arndb.de>
X-Provags-ID: V02:K0:63+grPKyslMQDg7nNhqkh0LXQEzUNvK/D/EpS7hSrdY
 BET90N3Mu8hjjftXs34lWkR4SOR4XMWsDVsLCjgUjd022ekzWc
 w1fBSJ7Lc2OYFg+8I8LpiEUhKtRXLAh3tJL8qztXFfBiduE/le
 TXC1LkOGPuuYlQSt3FrQgZkkN6LydhE+6Mb+bpmyhQATH37vUj
 EwJMfe5D9FhoGoBuBl66g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (all arm builds)
> failed like this:
> 
> arch/arm/mm/Kconfig:835: syntax error
> arch/arm/mm/Kconfig:834: invalid option
> arch/arm/mm/Kconfig:838: unknown option "ARCH_PRIMA2"
> 
> Caused by commit 69ca71d177d1 ("Merge branch 'next/soc' of git
> +ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc into
> for-next-3") from the arm-soc tree.
> 
> This commit mismerged the config CACHE_L2X0 entry (forgot the \ on the end
> of one of the lines).

Thanks for the notification, the problem was in recreating the for-next
branch from the individual branches without testing the result. I'll
be more careful in the future about this.

I've uploaded a new for-next branch now, and will send out pull
requests for the next/* branches next.

	Arnd
