Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2DKISr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:18:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:1734 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2DKISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:18:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87729070"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: "'akpm@linux-foundation.org'" <'akpm@linux-foundation.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "'rusty@rustcorp.com.au'" <'rusty@rustcorp.com.au'>,
        "'a.p.zijlstra@chello.nl'" <'a.p.zijlstra@chello.nl'>,
        "'linux-kernel@vger.kernel.org'" <'linux-kernel@vger.kernel.org'>,
        "'yanmin_zhang@linux.intel.com'" <'yanmin_zhang@linux.intel.com'>,
        "'rostedt@goodmis.org'" <'rostedt@goodmis.org'>
CC: "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: [RFC 0/2] dump user space stack
Thread-Topic: [RFC 0/2] dump user space stack
Thread-Index: Ac0XpXMrB9NjJ+TRRsO00cW4fmSSgQADsvgAAAFyPXAAAFknUA==
Importance: high
X-Priority: 1
Date: Wed, 11 Apr 2012 08:18:31 +0000
Message-ID: <EE928378561BF1449699C96571234A740FCE374A@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3B8Itx8031549

Resend as linux-kernel kicked it back.

From: Tu, Xiaobing 
Sent: Wednesday, April 11, 2012 4:07 PM
To: 'akpm@linux-foundation.org'; 'mingo@elte.hu'; 'rusty@rustcorp.com.au'; 'a.p.zijlstra@chello.nl'; 'linux-kernel@vger.kernel.org'; 'yanmin_zhang@linux.intel.com'; 'rostedt@goodmis.org'
Cc: Zuo, Jiao
Subject: [RFC 0/2] dump user space stack
Importance: High


ã€€ã€€We often need user space stack call-chain information when debugging hard issues. Here is a prototype and it could work well on X86 architecture.
Â Â Â Â Â Â Â Â  The idea is to output user space stack call-chain from /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend it to output user space call chain
With hex format.
Â Â Â  In user space, we implement a backtrace tool, it read kernel space and user space stack call chain from /proc/xxx/stack, and converts the hex format into symbols., we tested it on i386/i686 and x86-64. It works well.

Br
Xiaobing


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
