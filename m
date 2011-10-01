Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1JALje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 07:39:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:61148 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1JALj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 07:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,472,1312182000"; 
   d="scan'208";a="57692852"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH v2] mtd: r852: make r852_pm_ops static
Thread-Topic: [PATCH v2] mtd: r852: make r852_pm_ops static
Thread-Index: AQHMe/HZCu4k9imlK0edcW29qXJZ45VnVcQA
Date: Sat, 1 Oct 2011 11:39:24 +0000
Message-ID: <1317469354.19426.88.camel@sauron>
References: <1317003183.6468.1.camel@phoenix>
In-Reply-To: <1317003183.6468.1.camel@phoenix>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.41]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F125DC298D8EA842863F038459C895BA@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p91Bdgp5006155

On Mon, 2011-09-26 at 10:13 +0800, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.
> Also make r852_suspend and r852_resume static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2: Also make r852_suspend and r852_resume static

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
