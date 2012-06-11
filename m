Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2FKO5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:57:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2FKO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:57:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 11/14] ARM: LPC32xx: DTS adjustment for using pl18x primecell
Date: Mon, 11 Jun 2012 14:57:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <201206111414.14264.arnd@arndb.de> <4FD60096.7050603@antcom.de>
In-Reply-To: <4FD60096.7050603@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111457.00845.arnd@arndb.de>
X-Provags-ID: V02:K0:rxpvT1nFkvIrj9G0iJZ79LsRZ0TNwJyTpA1HkVfGj39
 C/TXkGvr919axvQq4/95ykDpuESM2Xqu+4FXTVhIR25ouZjzYK
 lvNcfPW3fKrDM8/29sVd7GeLDibRC8btdHYS3scO90oKNfXRUZ
 nBfGwz37vk4BViaqi+iH7gzHJVS+sxGB9gShVzZx7DnOPcseGR
 mIBdjPOhhw7lbqg5LE03AHA+QDJc5p4zdMISZONpooJmAdKTEQ
 Fg4fxYh0OOqAYkwvS9+Iy5gBEk18pYo0X/iOyEF/K1xl9lC4CA
 69eq9FFpAjkKgldUYXaZ9zZ2osYHx7qu+Rl1OEjDsIZQat3AvR
 jAmwNX7at8xBOcGAiIXE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Roland Stigge wrote:
> Thanks for the note!
> 
> Funnily, I always did it this way. Looks like initially, I copied from
> somewhere else (wrongly). Indeed, we have lots of "disable", see also:
> 
> omap3-beagle.dts
> omap4-panda.dts
> omap4-sdp.dts
> tegra20.dtsi
> tegra30.dtsi

Ah, right. Note that the kernel checks only for "ok" and "okay" strings,
anything else is interpreted as "disabled". We should use the correct
string anyway of course.

	Arnd
