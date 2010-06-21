Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0FUTFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:05:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:15133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab0FUTFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,454,1272870000"; 
   d="scan'208";a="578431396"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
Date: Mon, 21 Jun 2010 20:05:14 +0100
Subject: RE: [Bug #16235] [REGRESSION] [IWL3945] Broadcast is broken?
Thread-Topic: [Bug #16235] [REGRESSION] [IWL3945] Broadcast is broken?
Thread-Index: AcsRciJ8Sppguvx4SwKRGRwzFAckRQAAjXQA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501A571FE33@irsmsx504.ger.corp.intel.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
 <W8JfMs9cZw.A.aOE.MMpHMB@chimera>
 <C5C86A19469DAE48AAAD0E5F3716E44501A571F996@irsmsx504.ger.corp.intel.com>
 <201006212045.32897.rjw@sisk.pl>
In-Reply-To: <201006212045.32897.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5LJ5aim030806

> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16235
> > > Subject		: [REGRESSION] [IWL3945] Broadcast is broken?
> > > Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> > > Date		: 2010-06-14 17:24 (7 days old)
> > > Message-ID	: <201006141924.24061.maciej.rutecki@gmail.com>
> > > References	: http://marc.info/?l=linux-
> kernel&m=127653628301300&w=2
> >
> > I asked Maxim to test a patch, which he has, and am in the process of
> pushing it upstream.
> 
> OK
> 
> Do you have a pointer to the patch?

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=4d23e4e5eb50431426facf192354ad2506e2dd40;hp=75c0adf46667859128dd515e1751ed171833219f

johannes
---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
