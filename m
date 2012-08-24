Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2HXEoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:44:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:41737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2HXEod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="190762687"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: RE: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Topic: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Index: AQHNgPi7ZJFyDkZcAUKuhoC56fsXb5doXm9A//+k7gCAAGA2cA==
Date: Fri, 24 Aug 2012 04:44:09 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD23F08C@BGSMSX102.gar.corp.intel.com>
References: <1345686558-16512-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120823063005.GL15548@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD23EFED@BGSMSX102.gar.corp.intel.com>
 <20120824042722.GA12291@lizard>
In-Reply-To: <20120824042722.GA12291@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7O4ignt001649

> > > > This patch checks for charger status register for determining the
> > > > battery charging status and reports Discharing/Charging/Not
> > > > Charging/Full accordingly.
> > > >
> > > > This patch also adds the interrupt support for Safety Timer Expiration.
> > > > This interrupt is helpful in debugging the cause for charger fault.
> > > >
> > > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > >
> > > Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > I got the Ack from Mika can you look into this patch.

I am assuming you will review/merge this patch
smb347_charger: fix battery status reporting logic for charger faults

> > Also I have submitted another patch which needs your attention.
> > [PATCH v2] power_supply: Added helper function to get the ps object
> > from supplied_to list
> 
> Can you please submit some user of this function?
Sure I will submit a supporting patch for this.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
