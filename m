Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2CMEx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:53:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51099 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2CMExy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:53:54 -0400
X-AuditID: cbfee60c-b7c83ae000001e65-9d-4f5ed2da9cb4
Date: Tue, 13 Mar 2012 04:53:46 +0000 (GMT)
From: PINTU KUMAR <pintu.k@samsung.com>
Subject: [INFO] : Hibernation and Resume between 2 similar devices
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Reply-to: pintu.k@samsung.com
MIME-version: 1.0
X-MTR: 20120313043637380@pintu.k
Msgkey: 20120313043637380@pintu.k
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120313043637380@pintu.k
X-ParentMTR: 
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <28119509.96581331614425960.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2D4s1EC018377

Dear All,

I am just curious to know if it is possible to "Hibernate in one device" and "Resume the hibernated image from another similar device".

Suppose, I have 2 exactly similar device (Laptop or mobile phone) with me.
At one time I will be working on only one device at a time.
Suppose I started my work on "Device 1"  with few opened application and later I wanted to switch to "Device 2" which is exactly similar to Device 1.
I thought to hibernate (suspend to disk) the Device 1 and store the hibernated image as a swap file and later transfer to sd card.
Then take of the sd card from Device 1 and put it into Device 2.
Copy the swap file from sd card to Device 2 in some swap partition.
Then reboot the Device 2 to Resume from this swap file.
I will get back my Device 1 content in Device 2.

Hope this is possible ?

Any comments.....

Regards,
Pintu




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
