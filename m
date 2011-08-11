Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1HKUmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:42:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab1HKUmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:42:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Aug 11 (suspend_stats build error)
Date: Thu, 11 Aug 2011 22:44:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au> <20110811115931.8007900d.rdunlap@xenotime.net>
In-Reply-To: <20110811115931.8007900d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108112244.12547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 11, 2011, Randy Dunlap wrote:
> On Thu, 11 Aug 2011 16:20:58 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> When CONFIG_PM_SLEEP is not enabled:
> 
> kernel/built-in.o: In function `suspend_stats_show':
> main.c:(.text+0x40a25): undefined reference to `suspend_stats'
> main.c:(.text+0x40a2c): undefined reference to `suspend_stats'
> main.c:(.text+0x40a32): undefined reference to `suspend_stats'
> main.c:(.text+0x40a73): undefined reference to `suspend_stats'
> main.c:(.text+0x40a82): undefined reference to `suspend_stats'
> kernel/built-in.o:main.c:(.text+0x40a91): more undefined references to `suspend_stats' follow

Should be fixed in my tree now.

Thanks,
Rafael
