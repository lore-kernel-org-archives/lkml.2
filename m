Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab2FBCuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 22:50:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764Ab2FBCui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 22:50:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] clock: max77686: Add driver for Maxim 77686 32KHz crystal oscillator
Date: Sat, 2 Jun 2012 02:50:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        H Hartley Sweeten <hsweetn@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com> <201206011613.33706.arnd@arndb.de> <20120601162118.GA24139@opensource.wolfsonmicro.com>
In-Reply-To: <20120601162118.GA24139@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206020250.21967.arnd@arndb.de>
X-Provags-ID: V02:K0:NQTAWt/+HMm1P5glS4KgDXymzmlAolt8ATa/Q3Y8luv
 wypjyJfx0UFqktO/XA/TFU6+r3X09eiRz+uzwEVZqBbF3QOgsy
 w89yvNdFvHP2PEuPBXpov/9n2zLmCvDwFSdoRC+8tjeWaPIGDX
 LkTYfaN2WlC19IuHG8W1ImwBGD6dIcMdlAOytOl7gFMfxAlDmc
 NCdtmjsAS6hb7LQfeGYcjHgcO1gNUS3tWX+PwQ+56w2ujVYPnN
 jby2Id1HAJfBtdogTXo95AW79kat/tbFnMJxZOysjsIwjw9NtR
 Or9hL0scFK1VfNMNE7UBaYYQ1N5USZmwbW9YOliTP5X6s2GCiP
 XK4Kmphw7SVFiih7eS80=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2012, Mark Brown wrote:
> On Fri, Jun 01, 2012 at 04:13:33PM +0000, Arnd Bergmann wrote:
> 
> > You should also have an of_device_id table so you can match this driver from
> > device tree definitions.
> 
> There has been...  some discussion on the value of doing this for MFD
> cells where the MFD cell has no reuse capability (eg, when the driver
> has very little abstraction from the top level chip binding) since we
> don't really get anything from the abstraction if the driver can't be
> reused and may limit ourselves (and others) in future.

Ok, makes sense.

	Arnd
