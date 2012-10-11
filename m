Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab2JKBUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:20:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:47307 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883Ab2JKBUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="203050536"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: anish kumar <anish198519851985@gmail.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNpqL6iLZgSIxMH0GKmzwm7ve2K5eyQk0AgAEKtWA=
Date: Thu, 11 Oct 2012 01:20:15 +0000
Message-ID: <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
 <1349880328.22926.2.camel@anish-Inspiron-N5050>
In-Reply-To: <1349880328.22926.2.camel@anish-Inspiron-N5050>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9B1Kasm007060

> From: anish kumar [mailto:anish198519851985@gmail.com]
> Sent: Wednesday, October 10, 2012 8:15 PM
> To: Tc, Jenny
> Cc: myungjoo.ham@samsung.com; cw00.choi@samsung.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] extcon : callback function to read cable property
> 
> I think the reason why we have extcon is in first place is to only notify the
> clients of cable connection and disconnection and it is up to the client to
> decide what else to do with the cable such as finding which state it is in and
> other details.
> So I feel this should not be handled in the extcon.
> 
> However it is up to the maintainer to decide.

Once the consumer gets the notification, it needs to take some action. One of the action is to read the cable properties. This can be done by proprietary calls which is known both to the consumer and the provider. My intention is to avoid this proprietary calls. Since both the provider and consumer are communicating with the extcon subsystem , I feel having a callback function of this kind would help to avoid the use of proprietary calls. Also I agree that extcon notifier chains are used to notify the cable state (attach/detach). But if a cable has more than two states (like the charger cable) how do we support it without having a callback function like this? Let the maintainer take the final decision.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
