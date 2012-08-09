Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2HIGta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:49:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41735 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2HIGt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:49:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6797"; a="222859705"
X-IronPort-AV: E=Sophos;i="4.77,738,1336374000"; 
   d="scan'208";a="160364884"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNddTR6PRqpmernk28qOEelr0rNJdQvhvwgACVLgD//5K5UIAAkSUA//+OvXA=
Date: Thu, 9 Aug 2012 06:49:25 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
References: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
	<1344485382.2024.9.camel@joe2Laptop>
	<6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
 <20120808.231804.12694947300243733.davem@davemloft.net>
In-Reply-To: <20120808.231804.12694947300243733.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q796naoK025369



>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net]
>Sent: 2012Äê8ÔÂ9ÈÕ 14:18
>To: Ren, Cloud
>Cc: joe@perches.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>qca-linux-team; nic-devel; Huang, Xiong; hao-ran.liu@canonical.com; Rodriguez,
>Luis
>Subject: Re: [PATCH] net: add new QCA alx ethernet driver
>
>From: "Ren, Cloud" <cjren@qca.qualcomm.com>
>Date: Thu, 9 Aug 2012 04:44:08 +0000
>
>> I only want to do some additional explanations to david. It makes nothing with
>original patch.
>
>Stop this TOP POSTING, it's bad etiquette on a technical mailing list.
>
>Look at how other people write their email responses on this mailing list.  They
>first provide a quoted portion of what they are replying
>to:
>
>> Quoted
>> something like this.
>
>And then they provide their response UNDERNEATH.
>
>When you provide your response at the top of the email, it is unexpected, and
>makes more work for people reading what you write.
>
>You guys are doing everything possibly wrong.
>
>You have unnecessarily quoted a HUGE patch just to provide some ancillary in
>formation.
>
>You are TOP POSTING.
>
>You added a signoff of someone who did not give you explicit permission to do
>so.
>
>And you seem to not comprehend nor care about the implications or effects of
>your actions that are hurting other people and creating a huge brudon.
>
>I very much intend to simply ignore your work completely until you can get your
>act in gear, write proper emails, and submit patches properly.
>
>It is the only deterrant I have for your incredibly rude and inconsiderate
>behavior.


Hi David,

Please calm down. I will follow rule of sending email from now on. Sorry for causing
your trouble. Luis has ever asked joe for adding as a Signed-off-by. At that time joe agreed
with it. If joe prefers his name not be listed as a Signed-off-by, I will respect his decision.
alx driver is innocent. Please help review.  Thanks

cloud


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
