Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2AJJGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:06:32 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51458 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2AJJG2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:06:28 -0500
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Tue, 10 Jan 2012 01:05:39 -0800
Subject: RE: [PATCH v4 2/3] ARM: mmp: enable pinmux in mmp platform
Thread-Topic: [PATCH v4 2/3] ARM: mmp: enable pinmux in mmp platform
Thread-Index: AczPdR/SSp6bFZa9SryhdVkJYb3ZMwAAeZZV
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C060A87D719@SC-VEXCH1.marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
	<1325643995-20745-3-git-send-email-haojian.zhuang@marvell.com>,<CACRpkdbPk8GEvW7uewMXZcW7ghfry8X0Hgiz3uj4zOrpDgK4hQ@mail.gmail.com>
In-Reply-To: <CACRpkdbPk8GEvW7uewMXZcW7ghfry8X0Hgiz3uj4zOrpDgK4hQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you mean the 1st & 2nd patch or the 3rd patch?

Thanks
Haojian
________________________________________
From: Linus Walleij [linus.walleij@linaro.org]
Sent: Tuesday, January 10, 2012 4:52 PM
To: Haojian Zhuang
Cc: swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; eric.y.miao@gmail.com; linux@arm.linux.org.uk; arnd@arndb.de
Subject: Re: [PATCH v4 2/3] ARM: mmp: enable pinmux in mmp platform

On Wed, Jan 4, 2012 at 3:26 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Configuring pinmux in brownstone, aspenite & ttc dkb platform. The functions
> of pins are initialized in platform driver.

I tried to apply this patch but I can't, I suspect it is dependent on
some changes
in the PXA tree?

I can apply this after the merge window once PXA is pulled in and ready.

Yours,
Linus Walleij
