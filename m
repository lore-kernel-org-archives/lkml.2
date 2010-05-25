Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab0EYA5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:57:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48393 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab0EYA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:57:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <410FE99A91C44DBB9195120FE1434FE0@rainbow>
From: "Iram Shahzad" <iram.shahzad@jp.fujitsu.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Cc: <linux-kernel@vger.kernel.org>
References: <06EE497F774E482693005209CB740D6A@rainbow> <4BFB0C77.2030904@am.sony.com>
Subject: Re: FUNCTION_TRACER: can it be used to trace early bootup functions
Date: Tue, 25 May 2010 09:58:44 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim

Many thanks for the information. I am sorry I did not mention
that my purpose this time is to know the calling sequence of the
functions rather than to measure the timings.
Anyway the information is useful to me.

It seems there is another tracing mechanism called KFT.
http://elinux.org/Kernel_Function_Trace
>From the examples in the above URL, it looks like it can
start tracing from start_kernel.
But it seems it is neither mainlined nor actively maintained.
Any idea about its status?

Thanks
Iram


