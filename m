Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2BMUBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:01:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4198 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab2BMUBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:01:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Feb 2012 12:01:14 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>
Date: Mon, 13 Feb 2012 12:01:14 -0800
Subject: RE: [PATCH 0/3] pinctrl: move the core per-device handlers to core
Thread-Topic: [PATCH 0/3] pinctrl: move the core per-device handlers to core
Thread-Index: AczqiHDPtaSKkaPMRX2WG+jZD71D/AAAZYRg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178EF838ED@HQMAIL01.nvidia.com>
References: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
	<4F34A3EF.3070207@nvidia.com>
	<CACRpkdZ0kTXLAfdsfMjeZZX4W-fx5zyEdeGboKCmKSzCaMVw_A@mail.gmail.com>
	<4F360853.3050402@nvidia.com>
 <CACRpkdYm3sb7wbJP1M9HmjkGHq1YuT06ar6-+V1RoZ1QdoT9BA@mail.gmail.com>
In-Reply-To: <CACRpkdYm3sb7wbJP1M9HmjkGHq1YuT06ar6-+V1RoZ1QdoT9BA@mail.gmail.com>
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

Linus Walleij wrote at Monday, February 13, 2012 12:48 PM:
> On Sat, Feb 11, 2012 at 7:18 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > I'll probably want to rework the 3 patches your changes break anyway (in
> > order to completely remove use of board-*-pinmux.c when booting from DT,
> > once I write the DT code) and so you may as well not apply them, just
> > the driver itself. It'll save some churn.
> 
> OK will that happen for this merge window or is the driver going to sit
> unused for the 3.4 cycle?
> 
> I'm mainly thinking if the underlying driver may be subject to change I
> could just keep it out-of-tree, unless you want it merged in for some
> practical reason, then I'll just merge it.

IIRC, people hoped that the common pinctrl bindings would make it into
3.4. If that happens, the driver won't be unused in 3.4.

I don't foresee any changes to the driver except those driven by any
changes to the core pinctrl itself, so I don't foresee any need to keep
it out of tree.

-- 
nvpublic

