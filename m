Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2ARBRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:17:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab2ARBRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:17:32 -0500
X-AuditID: cbfee60f-b7bceae00000240c-d0-4f161daba0ce
Date: Wed, 18 Jan 2012 01:17:31 +0000 (GMT)
From: JONGMAN HEO <jongman.heo@samsung.com>
Subject: build failure with current linus tree
To: linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20120118011621422@jongman.heo
Msgkey: 20120118011621422@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120118010825751@jongman.heo
X-ParentMTR: 20120118010825751@jongman.heo
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <27516709.76321326849450926.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0I1HcNw021218


With current linus git (commit a25a2b84), I got following build error,

arch/x86/kernel/vm86_32.c: In function ??do_sys_vm86??:
arch/x86/kernel/vm86_32.c:340: error: implicit declaration of function ??__audit_syscall_exit??
make[3]: *** [arch/x86/kernel/vm86_32.o] Error 1

I do not have CONFIG_AUDITSYSCALL in my .config.

Regards,
Jongman.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
