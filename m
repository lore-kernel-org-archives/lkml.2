Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2EOONW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:13:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2EOONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:13:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/12] pinctrl for Ux500 and Nomadik family
Date: Tue, 15 May 2012 14:13:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>
References: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com> <201205151246.45384.arnd@arndb.de> <CACRpkdbjCBi2tkPE-yV7NdHOsMZ_XHuHr3nDUnRekxDDoqRRfw@mail.gmail.com>
In-Reply-To: <CACRpkdbjCBi2tkPE-yV7NdHOsMZ_XHuHr3nDUnRekxDDoqRRfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151413.04763.arnd@arndb.de>
X-Provags-ID: V02:K0:GyakVHSZIYIYZ6mUToFQ2iUkx9P9xVBnbdi8nn6jIEA
 gi9M1S715vI56pyhOWhbcAYy66/2RRnDrnawsEGcPYZ9gSP944
 MEBuHQqX8T2L/tKuFFj60AMP+a71C4mZHjCkRXGAc1sHp0aIZV
 0Pdcu/bhgBtGneYZ1uQbabapF76fc3Pt1jJq3dL93LBEFUwql2
 dTku3nOutiG977X8W+bm7qhGC0urEIG6CgOtW/jl07iNZtxMYn
 WHj2fc3q/z7WvciSSMCe3ftSye1qMlXDnJ+KhkZRwDmX70MGcA
 jjwSV85ghowXkgUGtFpFWEkbahzLba/rwRwiNyremSCDE7HnpM
 tJKwqvZ+f3xPjRphLiPw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Linus Walleij wrote:
> On Tue, May 15, 2012 at 2:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > One option would be that you just try to be very early with sending your
> > branch and arm-soc goes directly after that, another option would be that
> > we send a pull request for your tree along with the stuff that depends on
> > it, with your permission.
> 
> Either way is fine with me, I was planning to send a pull request as soon
> as the merge window opens anyway. If you need it, I can lock down the
> pinctrl tree and prepare the pull tag.

Ok, that's good then. I guess we can just wait until your pull request is
out and put a note in the ones from arm-soc that depend on it.

	Arnd
