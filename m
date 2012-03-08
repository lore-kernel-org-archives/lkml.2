Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2CHQDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:03:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab2CHQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:03:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 0/3] introduce stmp-style devices
Date: Thu, 8 Mar 2012 16:03:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203081603.12817.arnd@arndb.de>
X-Provags-ID: V02:K0:8fXbmq5D+flxcBLZVyyzM5hAjHvkPXGODocB/v6y7Em
 BGPKJkRj35tdxJkQB8UUW0Dv/VFMbWoEgiU9XklzcfaDhGuXNy
 1kHE3xvFqhJSQvWG98rujRar5as1BN39+t052n3VEdFF/T7Jv4
 Pjp8Xk1Oky0Y7OCJg0QCo2hA/ypXQ6b3qUmpwrSfPtU0ggejmR
 iG9yYXiR22FvzMrJJKs4v3vnfkq6ge7I10cSiIkURdcMptJ99l
 5Dt7GcRR4phYh/xuUVjQQBtckfZRFEtEYbN4ZFch6w7TOwZkxM
 FFCOO0QVXqjZB/ctNquDm7epJvLBygCzqpeEyW6q9APL+5m0PX
 uumA7748+MTTA/NmQpUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2012, Wolfram Sang wrote:
> 
> This series makes support for a certain type of devices mach independant. We
> want that because such devices (having a special register layout) have been
> found in mach-mxs and mach-mx6 meanwhile. Please refer to patch 1/3 for a more
> detailed description.
> 
> Patch 1/3 adds the basic support and is of main interest to get upstream.
> Patches 2/3 and 3/3 are usage examples and will be send to the relevant
> subsystems once the basic support is accepted.
> 
> Main changes since the RFC:
> 
> * renamed the macros to STMP_OFFSET_*
> * rebased to 3.3-rc6
> 
> Tested with a TX28 board.

I think having the stmp_device code is good, but I'm not sure about the
location in drivers/base, which is otherwise reserved for anything related
to 'struct device'. How about putting the same file into lib/stmpregs.c?

	Arnd
