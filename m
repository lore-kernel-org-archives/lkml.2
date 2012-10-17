Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2JQIgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:36:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:39563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab2JQIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,599,1344236400"; 
   d="scan'208";a="207058942"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Wei Ni <wni@nvidia.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
Subject: RE: How can I get the latest generic thermal framework
Thread-Topic: How can I get the latest generic thermal framework
Thread-Index: AQHNrDdEr1km7BgAt0CCNhqbWizwcJe9LFIA
Date: Wed, 17 Oct 2012 08:36:39 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591E7D05@BGSMSX101.gar.corp.intel.com>
References: <1342088573.27605.101.camel@tegra-chromium-2>
  <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
  <1342144273.1682.237.camel@rui.sh.intel.com>
  <1342164616.27605.129.camel@tegra-chromium-2>
 <1342165278.1682.259.camel@rui.sh.intel.com> <507E5B15.8040107@nvidia.com>
In-Reply-To: <507E5B15.8040107@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9H8axc0002742

Hi Wei,

You can pull the latest changes from Rui's -next tree here:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
(use -next branch)

Thanks,
Durga

> -----Original Message-----
> From: Wei Ni [mailto:wni@nvidia.com]
> Sent: Wednesday, October 17, 2012 12:46 PM
> To: Zhang, Rui; R, Durgadoss; Brown, Len
> Cc: khali@linux-fr.org; joe@perches.com; linux-kernel@vger.kernel.org;
> linux-tegra@ger.kernel.org; Alex Courbot
> Subject: How can I get the latest generic thermal framework
> 
> Hi, all
> Several months ago, I tried to use the generic thermal framework to work
> with the lm90 driver on our SOC, but this work was not completed, and it
> was pended.
> Now I want to start it again. I noticed that many new patches of this
> framework were submitted, I checked linux-next.git, but it seems they
> were not merged.
> How can I get the latest codes for this thermal framework? which git
> repository should I use?
> 
> Thanks.
> Wei.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
