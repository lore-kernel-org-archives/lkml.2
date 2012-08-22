Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2HVLl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:41:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51316 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2HVLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:41:53 -0400
Date: Wed, 22 Aug 2012 19:42:14 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: jbaron <jbaron@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: About multiple queries to control using $DBGMT/dynamic_debug/control
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208221942104377284@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7MBg290024616

Hi,
	I used the $DBGMT/dynamic_debug/control to control printing debuginfo.But When i wote multiple queries which has at least one didn't match,
the result is ok which no error can return.
	So i think i wrote correct queries.But until using dmesg, i only found error.
	And if parm verbose of dynamic_debug is zero, i can't find the result by dmesg.
	So i think it's not convenient.
	If it did not found any query,it should return error.

Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
