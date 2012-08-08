Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab2HHQWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:22:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab2HHQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:22:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
Date: Wed, 8 Aug 2012 16:22:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Takashi Iwai <tiwai@suse.de>, Laxman Dewangan <ldewangan@nvidia.com>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-12-git-send-email-arnd@arndb.de> <50228889.5060709@wwwdotorg.org>
In-Reply-To: <50228889.5060709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081622.29777.arnd@arndb.de>
X-Provags-ID: V02:K0:bt7qlNGlY3GcKnDJGQ6ZtuiVxqXueVH9HRn5GDk0vMN
 cJ7MWskwQ4oPHoQzfjZTYey+XKDJPj03LOAAtmlp/4HPVHWm1H
 XNu8CafYc+aIdDjM1Qh9m9UEAsHtBTcB4k+F0Dt2VQ/0TFVB3G
 HvFwObBuWaRNLYS+onoAqC794WP3Um9TmCBTH2KafD8YNT3I8P
 NE2IVOP2FsZzcEervv2CgzHkFU+gJIKoJc2hV/4VV+zIZeqD/N
 F9Bz5SB6Oy1yvML7KPnbvR6w7j90P6uJFKn6zjhJ7gKirJu7hV
 qW6UIgdBKAnaXIN3BJJ7LZ4irufnI7Zgvcka0Wbu+ZBvJAXyIW
 nrkLwZiFkea1wuHKEofI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Stephen Warren wrote:
> On 08/08/2012 08:47 AM, Arnd Bergmann wrote:
> > A few drivers use a construct like
> > 
> >  #ifdef CONFIG_PM
> >  static int foo_suspend(struct device *pdev)
> >  {
> >     ...
> >  }
> >  static int foo_resume struct device *pdev)
> >  {
> >     ...
> >  }
> >  #endif
> >  static SIMPLE_DEV_PM_OPS(foo_pm, foo_suspend, foo_resume);
> ...
> > drivers/i2c/busses/i2c-tegra.c:716:12: warning: 'tegra_i2c_suspend' defined but not used [-Wunused-function]
> > drivers/i2c/busses/i2c-tegra.c:727:12: warning: 'tegra_i2c_resume' defined but not used [-Wunused-function]
> 
> Laxman already posted a patch for this, which I'm hoping will make it
> into 3.6, through the I2C tree.
> 
> http://www.spinics.net/lists/linux-i2c/msg09359.html

Ok, dropping this one then.

Thanks,

	Arnd
