Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1DQUPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:15:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1DQUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:15:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [12/74] staging: usbip: bugfixes related to kthread conversion
Date: Sun, 17 Apr 2011 22:15:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>
References: <20110413155144.231263288@clark.kroah.org>
In-Reply-To: <20110413155144.231263288@clark.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172215.01736.arnd@arndb.de>
X-Provags-ID: V02:K0:KOiLCnBldTtBeUVfRtpVxt9fhyw3h/D8wYXSL0+Rrc5
 sDvH4lWJSaoMt2XUtObdzG2pQLo48BbpBd8JCF7N3pUNe+HFoy
 Oyjc7a+V6reeYCCa38ptCa7JjIn7gNmTyezK38GEbzrfa1Sx9d
 W7Ucf2ini1W5i4Dv8pq0y30nFTG1p/lrsjqJkeK8qDfbecAAJf
 PzKUA2FuBiljR9Wfi7pnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 April 2011, Greg KH wrote:
> From: Arjan Mels <arjan.mels@gmx.net>
> 
> commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.
> 
> When doing a usb port reset do a queued reset instead to prevent a
> deadlock: the reset will cause the driver to unbind, causing the
> usb_driver_lock_for_reset to stall.
> 
> Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
> Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> Cc: Max Vozeler <max@vozeler.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 

I think either the subject line is misleading or the patch is not
needed in -stable. The kthread conversion was done in 2.6.38, so
any bug introduced by it would not need to be fixed in an earlier
version, afaict.

	Arnd
