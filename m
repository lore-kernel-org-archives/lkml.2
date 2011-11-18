Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1KRRGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:06:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1KRRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:06:52 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=56UTa_Yws6AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=aBzaLlHhfHKPobfVBkgA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 3/3] ktest: allow success logs to be stored
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1321616131-21352-3-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
	 <1321616131-21352-3-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 12:06:50 -0500
Message-ID: <1321636010.3533.57.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:05 +0530, Rabin Vincent wrote:
> Add a STORE_SUCCESSES option, to allow success logs to be stored, for
> example to double-check or otherwise post-process the test logs.
> 

This was actually on my todo list, so thanks for taking that off for me.
But I want to let you know that new features like these wont be pushed
to mainline until the next merge window. I already added it to my queue
for 3.3. I'll be pushing to my tree sometime in the later -rc cycles.

Thanks again,

-- Steve


