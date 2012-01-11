Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2AKAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:25:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46893 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2AKAZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:25:56 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-2d-4f0cd71342bf
From: Chanho Park <chanho61.park@samsung.com>
To: "'Tejun Heo'" <tj@kernel.org>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-10-git-send-email-tj@kernel.org>
In-reply-to: <1326220106-5765-10-git-send-email-tj@kernel.org>
Subject: RE: [PATCH 9/9] block, trace: implement ioblame - IO tracer with
 origin tracking
Date: Wed, 11 Jan 2012 09:25:54 +0900
Message-id: <008401cccff7$950164b0$bf042e10$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczPxeQkjndiYGyLRHGYavpo1G8l5AAMISBg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ioblame.h>

I can't find it from patchset. So when compiling, I've got below error.

CC      kernel/trace/power-traces.o
kernel/trace/ioblame.c:308: fatal error: trace/events/ioblame.h: No such
file or directory
compilation terminated.
make[2]: *** [kernel/trace/ioblame.o] Error 1
make[2]: *** Waiting for unfinished jobs....

Are you forgot to attach it or just only RFC?

Best regards,
Chanho Park

