Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2HFSd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:33:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44792 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2HFSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:33:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <A6A3B7488C419F488E5B13FFD03C08AD2F4362EE@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
	<CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
	<A6A3B7488C419F488E5B13FFD03C08AD2F4362EE@SN2PRD0510MB370.namprd05.prod.outlook.com>
Date: Mon, 6 Aug 2012 11:33:21 -0700
Message-ID: <CAOesGMh=6QrCmL4EqnSqTxi1nH+8Wn+x=z9BYq8QJCznH3a=zQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=ED=9A=8C=EC=8B=A0=3A_=5BPATCH=5D_ODROID=2DX=3A_hkdk4412=3A_Add_new_hard?=
	=?UTF-8?Q?ware_based_on_Exynos4412?=
From: Olof Johansson <olof@lixom.net>
To: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 6, 2012 at 11:16 AM, Dongjin Kim
<Dongjin.Kim@agreeyamobility.net> wrote:
> Hello Tomas,
>
> I am agree with you to look at using device tree and I have some plan for it.
> But as of now I am focusing to bring up the hardware itself with mainline kernel and merge into it.
> I also need some time to look at the requirement of device tree, because I am not familiar with it yet.
>
> Any advice will be welcomed.

Basic rule (that has some flexibility for legacy platforms) is that
the net movement of board support should move from board files to
device-tree based. Introduction of a brand new board like this is a
prime example of something that should be using device tree from day
1.


-Olof
