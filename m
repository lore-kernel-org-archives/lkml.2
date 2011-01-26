Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1AZMx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:53:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1AZMx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:53:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 15/20] ufs: remove the BKL
Date: Wed, 26 Jan 2011 13:53:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-16-git-send-email-arnd@arndb.de> <20110126023031.GA3160@elliptictech.com>
In-Reply-To: <20110126023031.GA3160@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101261353.21046.arnd@arndb.de>
X-Provags-ID: V02:K0:yJwRONzfr1mX70xZAlDWX6uNQ5RXKkLgofDk3ce8PBI
 O/qZ/MdWkMc3TcBqRaBahT801ZcDI2Bguoo4IRfU2+Itn1fxZ2
 kKc44Mv68RC1XZQvEiSX7giAtOzVazbrQLXbGUaLSx6hlykJYj
 wAFzOruSwGh3KtbQHYd7+fPQ2hsrkdE6hlXcSiO3xsgjc2d42M
 qwC8nN11PnDVbBkB3bHiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 January 2011, Nick Bowler wrote:
> The sbi->mutex lock used by these functions is never initialized, which
> causes an insta-crash on mount.  With a mutex_init call added to
> ufs_fill_super, there are no obvious problems with my read-only
> mounts after some (very light) testing.

Thanks for the testing!

I fixed it up now and pushed the new version to the "final" branch of my
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git tree.

	Arnd
