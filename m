Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0EXGxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:53:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52862 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0EXGxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:53:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <06EE497F774E482693005209CB740D6A@rainbow>
From: "Iram Shahzad" <iram.shahzad@jp.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Subject: FUNCTION_TRACER: can it be used to trace early bootup functions
Date: Mon, 24 May 2010 15:55:20 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to know whether the Kernel Function Tracer
(kernel/trace/trace_functions) be used to trace early kernel
bootup functions starting from start_kernel?
My arch is ARM, by the way.

I have done some trials but it doesn't seem to trace early
bootup functions. I even made it the default tracer replacing
the nop tracer, but still it doesn't give me trace from
start_kernel.

Looking at the source code, it seems to me that it starts
recording data only after its own initialization. So does it
mean that by design it does not support early tracing?

Please CC me in the reply.

Thanks in advance
Iram


