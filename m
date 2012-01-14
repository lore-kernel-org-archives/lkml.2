Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2ANFku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:40:50 -0500
Received: from nm19.bullet.mail.sp2.yahoo.com ([98.139.91.89]:28879 "HELO
	nm19.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751094Ab2ANFkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:40:49 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 707843.58880.bm@omp1033.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=ZV1nB2QNspXHuncPYNFcacq3pGnLJFz9pnCqMXZb4BbU5y4uc9inkiOJSS+4YK+MXdZ6AqSu2x0W255QXXamEZ2e+Lm9fABL9yda81Iq6iqcnxXgYPs71D6Yg5SCmNdVM0ALt4ZFPsMbQmzBd/xqXkzQLd1NCbxQfy+wMEsGJJs=;
X-YMail-OSG: 8P0R.6IVM1moblSUoMM3n_DEcfR6_uBvG9JigWJ1CIKgoIu
 EJFt2w6GdovZbcxtIls6yE9mpWDkdRkuWbfIcsdQRuTgZfk58xvyxuM4beQj
 LrG7qdR2zoKxjenFmt5yML2BXVcHu_7I3aEubNMm5pTANuFEhr7y8LybXw2m
 rN_l3U2zGyRza2WH4y3Yr7SS821MBAdqt.POEKl2XuhcpXaLjKvX0k4cMI98
 PCFkLKRqz.kd1VrBmSr3B0KxaFiDmRLVEPTuyVk0Io3Cqpz9E3lp9W1Pbrof
 ZkuNhw6O3kC7d8U6VfrwNc_QMhsubxGOHOt1hKvatxonoyjBRINgATl60djl
 W7fVaq86lU5YDdJmsUdEoI41gATMds5Dc4dfpduamBmd_bodwTJg4BREDOtZ
 JqOBNkS0QvMQKXM_LAQI_cOfFFZ86gdjneqrfe8498Jg-
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1326519475.54455.YahooMailNeo@web112702.mail.gq1.yahoo.com>
Message-ID: <1326519648.92006.YahooMailNeo@web112707.mail.gq1.yahoo.com>
Date: Fri, 13 Jan 2012 21:40:48 -0800 (PST)
From: Feng Ye <f_ye@yahoo.com>
Reply-To: Feng Ye <f_ye@yahoo.com>
Subject: How to wait for threaded irq handler to finish, as in work queue flush/cancel?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1326519475.54455.YahooMailNeo@web112702.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,


I have a question regarding how to cancel threaded irq handler in a driver's suspend function.
If it's NOT threaded irq, normally you have a work queue, and in the suspend function, you call either cancel_work_sync() or flush_work(), these function will WAIT for the work queue to finish if it's in the middle of something.
However if you use threaded irq, then you don't need a work queue, then in the suspend function, I don't know if there's a simple function that can be used to cancel and wait the thread to finish?


Thanks,
Feng
