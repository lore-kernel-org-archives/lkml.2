Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2JIBY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 21:24:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11049 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2JIBY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 21:24:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6859"; a="247441951"
X-IronPort-AV: E=Sophos;i="4.80,556,1344236400"; 
   d="scan'208";a="124723937"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        nic-devel <nic-devel@qualcomm.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        qca_vkondrat <qca_vkondrat@qca.qualcomm.com>
Subject: RE: [PATCH] compat-drivers: update ethernet driver alx in crap dir
Thread-Topic: [PATCH] compat-drivers: update ethernet driver alx in crap dir
Thread-Index: AQHNopm38eYJRzZAD0mEleUKAYN7h5ewd7AA//+8jlA=
Date: Tue, 9 Oct 2012 01:24:55 +0000
Message-ID: <157393863283F442885425D2C45428562A50158C@nasanexd02f.na.qualcomm.com>
References: <1349400892-25315-1-git-send-email-xiong@qca.qualcomm.com>
 <CAB=NE6VotAu-cugsn4==3TPX0OGPEFtdn1J+5+Rd_YfLcg9YDQ@mail.gmail.com>
In-Reply-To: <CAB=NE6VotAu-cugsn4==3TPX0OGPEFtdn1J+5+Rd_YfLcg9YDQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.39.5]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q991P5f2002317

Hi Luis

    I'm refining the code, I try my best to make it upstream ASAP. Thanks !

-Xiong

> -----Original Message-----
> From: mcgrof@gmail.com [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Tuesday, October 09, 2012 6:25
> To: Huang, Xiong
> Cc: mcgrof@kernel.org; backports@vger.kernel.org; nic-devel; Ren, Cloud;
> Greg Kroah-Hartman; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-wireless; qca_vkondrat
> Subject: Re: [PATCH] compat-drivers: update ethernet driver alx in crap dir
> 
> On Thu, Oct 4, 2012 at 6:34 PM,  <xiong@qca.qualcomm.com> wrote:
> > From: xiong <xiong@qca.qualcomm.com>
> >
> > 1. support new device id (0x10A0/0x10A1).
> > 2. add DEBUG_FS interface for diag/swoi functions.
> >
> > Signed-off-by: Ren Cloud <cjren@qca.qualcomm.com>
> > Signed-off-by: xiong <xiong@qca.qualcomm.com>
> 
> Xiong,
> 
>  -- Vladimir, just a heads up -- this applies to you as well for the 802.11ad
> wil6210 driver
>  -- Greg, some review on your preference on this would be appreciated
> 
> The original alx crap patch was added into compat-wireless on the linux-3.5.y
> branch. Its been two kernel releases and alx is not yet upstream and users can
> only get alx via compat-drivers (technically compat-wireless as that was pre
> v3.7). v3.7 would be the *third* release in which this would happen... This is
> unfair to users and consumers of the Linux kernel and derails expectations and
> our arrangements for Linux kernel development. I realize that the goal was to
> get alx upstream ASAP but regardless of what the reason is, its not yet
> upstream. If you cannot work on alx on a timely manner to get upstream then
> please submit the driver to the staging area of the Linux kernel that Greg
> maintains so that other developers who may be able to help can submit
> patches to help you. Under staging your driver should be accepted so long as it
> compiles.
> 
> I will update the documentation for crap/ patches for compat-drivers to make
> it clear now that crap/ patches can be used for adding components / pieces of
> code not yet ready for upstream but as far as full new drivers are concerned
> you only get one kernel release cycle for it to linger on crap/ under compat-
> drivers, if you haven't addressed upstreaming yet then it should go to
> drivers/staging/. That is crap/ should only be used as a shortcut because users
> exist that can use the driver but you *do* have a team properly resourced to
> address upstreaming properly in a timely manner.
> 
> Linus should soon release v3.7-rc1 and new drivers are allowed to be merged
> during the RC cycles, as such my recommendation is instead of getting users to
> consume alx only through compat-drivers you now submit alx into staging to
> Greg in hopes that we can get it into v3.7-rcX some time, and at that time we
> can remove the crap/ patch from compat-drivers.
> 
> Users should be able to consume new drivers through kernel.org and compat-
> drivers should only provide the framework for backporting and also
> categorizing quick fixes. It should not be used for ongoing updates for new
> drivers that users need.
> 
> We must draw the line with crap/ patches somewhere.
> 
> I'll then take this patch for now but do expect you to get alx into either staging
> or proper upstream for the v3.7-rcX. I welcome feedback from other folks on
> the proposed arrangement for crap/ patches for compat-drivers.
> 
> https://backports.wiki.kernel.org/index.php/Documentation/compat-
> drivers/additional-patches#crap_patches
> 
>   Luis
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
