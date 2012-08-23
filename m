Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2HWMh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:37:27 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52033 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754587Ab2HWMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:37:23 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 1/1] tcp: Wrong timeout for SYN segments
Date: Thu, 23 Aug 2012 13:35:32 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6FC3@saturn3.aculab.com>
In-Reply-To: <1345724123.5904.756.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 1/1] tcp: Wrong timeout for SYN segments
thread-index: Ac2BKO1Ftym7JF4xRNyZeLZpZUz4jgAAq71g
References: <503419D3.1080700@linlab.net> <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com> <50361AEA.6010807@linlab.net> <1345724123.5904.756.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>, "Alex Bergmann" <alex@linlab.net>
Cc: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7NCbW7G030305

> I would suggest to increase TCP_SYN_RETRIES from 5 to 6.
> 
> 180 secs is eternity, but 31 secs is too small.

Wasn't the intention of the long delay to allow a system
acting as a router to reboot?
I suspect that is why it (and some other TCP timers)
are in minutes.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
