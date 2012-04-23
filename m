Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2DWUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:15:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2DWUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:15:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Sharing header files -- arch/arm/mach-generic  ?
Date: Mon, 23 Apr 2012 20:15:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@denx.de>, kernel list <linux-kernel@vger.kernel.org>,
        wd@denx.de
References: <20120423194042.GA5734@elf.ucw.cz>
In-Reply-To: <20120423194042.GA5734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204232015.41963.arnd@arndb.de>
X-Provags-ID: V02:K0:SfCNOM6NeAH01oKl2WBzMiYFCGp5jb1eDPWfbBCy5ZZ
 86pMqm7M0ftTLGsnYFsF7fJFR6LTAQv5deJ0JJMZZ3B1HIsvk4
 eifLWSYsWTvGqck+xClOsMtRPK17XFSn96j/lmIbT0o7pdYP8e
 Phcd8Ztjtn/KkCohYZO1xHsy9BsmvbRayk0hvYxvu4rRvOoarJ
 HRu8wgmP42xLRocqekNWoGK6/hqmWIU/nGAx92WaFcNGx/LF1x
 h2GB2T7mqcVZRSwCvKYIjZ9oXreICiRWkujHL4Dmt9xv4QAX3g
 Loe//4UM9OJ+d41HsXoVCZSUzXK1Ho8cy2//o943CDOIzWo1P3
 Ill76XNavliao9Z/qWtM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012, Pavel Machek wrote:
> I have new architecture I'd like to merge into the mainline. It has
> some code very similar to existing plaforms (for example
> real differences to mach-realview/platsmp.c are two lines.)
> 
> Is that a problem?
> 
> Should mach-generic/platsmp.c be created, so code can be better
> shared? Or are the code pieces small enough that this duplication can
> be ignored?

Hi Pavel,

I'd suggest you just post the code with the duplicate files
for review at first, and then we can discuss what to do with them.
As Russell mentioned, the code might not actually be ideal
in the duplicate version so you end up rewriting it, or there
might be a different solution that someone finds when we see the
patches.

	Arnd
