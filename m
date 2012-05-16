Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2EPPLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:11:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2EPPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:11:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver for BF60x family processors.
Date: Wed, 16 May 2012 15:11:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: sonic.zhang@analog.com, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com> <201205161339.41736.arnd@arndb.de> <20120516145333.GB1139@kroah.com>
In-Reply-To: <20120516145333.GB1139@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161511.27232.arnd@arndb.de>
X-Provags-ID: V02:K0:kHuaQ6N/H4EKv5ToTjRoItnHxSlCBppxXFlOcO8eRMU
 hJyy+bFwRmJXNAwauMYtxrLDR8aI+KVJS8TFyrG/iDgCyR+3jc
 HP83VrtRElF57U6lfH6l3hNwL7h1WCm2YAftLvWwmmXnVKBx6P
 +Oh2m4TQgIVwjl9SgNKz6diyz1Q/BNc4pHAahBDu2qSM071WvF
 mOYBOqyYiO+tP5ZLrrUlyqRDgjqEfbH/idwdWodc9bFAB2x+6c
 vLg6nEeDkZz1vFOEiRf+tBbmPtYhbDcjktUYlyPyOkaQKSYn+o
 Y74H24Wxa/Vt7R48qIwQrVG/JxloxD5Vi77S5Vw5i9G2kRIgyx
 3+iXko2lhwGQb6Y4bq10=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Greg Kroah-Hartman wrote:
> > Do we have a userspace crypto API these days? The last I remember every
> > attempt to add one so far was abandoned before it got merged. There is
> > drivers/s390/crypto/zcrypt*, which has a nonportable API, and 
> > then there is the in-kernel crypto layer in drivers/crypto that has
> > no user interface at all.
> 
> What is CONFIG_CRYPTO_USER for then, with the matching,
> crypto/crypto_user.c file?

Ah, I completely missed that going in and looked in the wrong place
when trying to find it now (/drivers/crypto, not /crypto). I'm glad
that part is resolved.

> > I agree that having another private driver for bfin_crc is not a good
> > idea, but I also don't have a better one.
> > 
> > About the driver itself, the submission seems incomplete (missing at
> > least the bfin_crc.h file) and the driver has a number of shortcomings
> > that we should discuss in case we decide to merge it.
> 
> I suggest at least tieing into the in-kernel crypto api first, and then
> worrying about the userspace side of things, right?

Absolutely.

	Arnd
