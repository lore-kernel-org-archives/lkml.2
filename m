Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2K1Czg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:55:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:29744 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2K1Czf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:55:35 -0500
From: "Yangbin (Robin)" <robin.yb@huawei.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fs@vger.kernel.org" <linux-fs@vger.kernel.org>
Subject: A question about proc file system
Thread-Topic: A question about proc file system
Thread-Index: Ac3NE9GjZW9380kcT0+O079jNM3EBA==
Date: Wed, 28 Nov 2012 02:55:30 +0000
Message-ID: <27C64424A5A15E448C64C14B9C9BC079112E05A3@szxeml526-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.168]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAS2tdHa004560

Hi all:

	I write a kernel module which make a dir and create a file in proc file system. 
I use proc_mkdir() and create_proc_entry() in init and use remove_proc_entry() in exit.
Now I got a problem during my test:
1. open terminal A, insmod and cd into the dir the module created in proc
2. open terminal B. rmmod and insmod angain.
Then I cannot see the file which should be created by the module, unless terminal A quit the dir.

This will be ok with regale file system like ext3, one teminal's operation will not affert others.
Is this a bug or not?

Regards
Robin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
