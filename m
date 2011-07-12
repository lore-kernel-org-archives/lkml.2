Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1GLSdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:33:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1GLSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:33:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Date: Tue, 12 Jul 2011 20:32:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
References: <1309876620.960.169.camel@L-0532.kpit.com> <201107051655.27990.arnd@arndb.de> <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F7008231@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F7008231@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122032.51847.arnd@arndb.de>
X-Provags-ID: V02:K0:ews9crKTUuXAAzf2oKACgnH95s4U8NzuyNbdcqj2svP
 p1vC9OYD00siH6M96VTg03NTtgJlxmSUCs/c+s8CBI0VeUt4EF
 CJMNRfgOQ02Yl4ps7WmVx2BP9DOnX4D4NgUr641oTNsrC9vUCk
 gZwcNZs86dBh97Y8Bxm0NxUNVEvGEGZ0xq5i2sJaXcWpweiEm7
 ruVJmeqI7IZPw5ibEqZFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 July 2011 08:57:46 Ashish Jangam wrote:
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: Tuesday, July 05, 2011 8:25 PM
> > To: Ashish Jangam
> > Cc: Mark Brown; sameo@openedhand.com; linux-kernel@vger.kernel.org; Dajun;
> > linaro-dev@lists.linaro.org
> > Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
> > 
> > On Tuesday 05 July 2011, ashishj3 wrote:
> > > The DA9052 is a highly integrated PMIC subsystem with supply domain
> > flexibility
> > > to support wide range of high performance application.
> > >
> > > It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> > > control and other functionality.
> > >
> > > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > 
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Can anyone ack this patch?

What do you think my message was? Reviewed-by is usually stronger than
Acked-by, it means that I actually had a closer look and am now happy
with the current state.

Of course, my Ack might not mean too much because I'm not a maintainer,
but I still would expect to be included in 'anyone'.

	Arnd
