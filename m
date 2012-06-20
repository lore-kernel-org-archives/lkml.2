Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2FTDjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:39:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:9939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab2FTDjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158469947"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Tc, Jenny" <jenny.tc@intel.com>
Subject: RE: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Topic: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Index: AQHNTnaUMlg1yyGKpEC3xOyeE2nkiJcCGMiAgAB2bWA=
Date: Wed, 20 Jun 2012 03:39:12 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD16C8DF@BGSMSX102.gar.corp.intel.com>
References: <1336413485-4585-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120619235022.GA12508@lizard> <20120620020359.GA14363@lizard>
In-Reply-To: <20120620020359.GA14363@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K3dN12032108

> > On Mon, May 07, 2012 at 11:28:05PM +0530, Ramakrishna Pallala wrote:
> > > Battery vendors like UER suggest to program Low Charge Voltage in
> > > case of high or low temperatures. So a battery can have different
> > > charge profile with in the battery operating temperature limits.
> > >
> > > Next, there could be events like drop or rise in VBUS voltage in
> > > that case we might have to adjust the charge current to stabilize VBUS
> voltage.
> > >
> > > This patch allows the Charger-Manager to adjust the charging
> > > parameters upon events like VBUS rise or drop and allows batteries
> > > to have multiple charge profiles for different temperature zones.
> > >
> > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > > ---
> >
> > Applied, thanks a lot!
> 
> Oh, actually. I see the feature is still under discussion. I really need some kind of
> OK/Ack from charger-manager folks before applying.

I will come with new patch once we come to a conclusion.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
