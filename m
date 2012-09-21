Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2IUEv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:51:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:7226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2IUEvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,459,1344236400"; 
   d="scan'208";a="147432728"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Topic: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Index: AQHNl3oNnREnR2Kb0UKopXTU7eVmR5eUOmhA
Date: Fri, 21 Sep 2012 04:51:17 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD286EFB@BGSMSX102.gar.corp.intel.com>
References: <1347985687-22676-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120919073734.GO15548@intel.com> <20120920214816.GB18223@lizard>
In-Reply-To: <20120920214816.GB18223@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8L4pakY008254

> On Wed, Sep 19, 2012 at 10:37:34AM +0300, Mika Westerberg wrote:
> > On Tue, Sep 18, 2012 at 09:58:07PM +0530, Ramakrishna Pallala wrote:
> > > This patch checks for charger status register for determining the
> > > battery charging status and reports Discharing/Charging/Not
> > > Charging/Full accordingly.
> > >
> > > This patch also adds the interrupt support for Safety Timer Expiration.
> > > This interrupt is helpful in debugging the cause for charger fault.
> > >
> > > Resending this patch because previous patch missed Anton's attention
> 
> Not that it missed my attention, it's just that I'm in "apply-mode"
> only 3-4 times per dev cycle. So, patches may lay in my "battery"
> folder for some time.
> 
> That's mostly because I have somewhat limited time, but also that way I can
> collect Acks and give other folks a chance to take a look at the patches.  :-)
> 
> But if you suspect the patch missed my attention (which also happens
> sometimes), it's totally fine to resend it or ping me, as you did.
> 
> > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> >
> > Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied, thank you guys!

Got it Thanks :-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
