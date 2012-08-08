Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2HHTOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:14:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2HHTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:14:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 04/11] ARM: ux500: really kill snowball_of_platform_devs
Date: Wed, 8 Aug 2012 17:19:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-5-git-send-email-arnd@arndb.de> <20120808162200.GB30473@gmail.com>
In-Reply-To: <20120808162200.GB30473@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081719.40749.arnd@arndb.de>
X-Provags-ID: V02:K0:I0FhhzoQA/IXedETZ9iOzGk7UJAiaP//TyAEEJFjc9+
 iXoHBHxxcNMalDYqwwZLrdTTRBWJwVchP6kRdFR232m7HBCd/r
 7oMQ6qyFPoxDyDX2RtQ+8/RhosyDNHVzUoCp62Yu9XWfWzHzLz
 EWVpHyIkcqFafakr5A34yToNiSHAnUPO7QkIXYfGPsLD9b+RZB
 IQmILK4V4WDtrvZH1jjhG7gOOgD+DeWepryPIdX826WyKoJGGY
 3mRojXibd1vIdAjctQiE0YZ8IJHOFaiW2y34I2rxQAAxQsJq+3
 WeUWnGcNRrLqh1590CxwsNDRKkav+pplA9CC8fqVQX+1XCoFHj
 wNCpkkhn4fJ0zjtd6fDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Lee Jones wrote:
> On Wed, Aug 08, 2012 at 04:47:21PM +0200, Arnd Bergmann wrote:
> > Commit fc67a597a "ARM: ux500: Remove temporary snowball_of_platform_devs
> > enablement structure" removed the only user of this variable, but did
> > not actually remove the array itself.
> > 
> > Without this patch, building u8500_defconfig results in:
> > 
> > arch/arm/mach-ux500/board-mop500.c:729:32: warning: 'snowball_of_platform_devs' defined but not used [-Wunused-variable]
> 
> I've already sent a patch that does this:
> 
> https://lkml.org/lkml/2012/7/31/305
> 
> Just waiting on Linus to review the set.

Ok, I've removed my version.

	Arnd

