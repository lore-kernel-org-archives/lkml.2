Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404Ab0GTT4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:56:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664Ab0GTTz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:55:58 -0400
X-Authority-Analysis: v=1.1 cv=yYDk9wvF9yILP8+WUBprz5rv2pbX1YDh8tMrnOgRP/g= c=1 sm=0 a=0kxkm8LpsyQA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=2rC8rupz0c9VLRWILtgA:9 a=S4liIuINxKS-Vcq5AoLmdC_lYZ0A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/2] trace-cmd: Fix a couple of crashes.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Jul 2010 15:55:55 -0400
Message-ID: <1279655755.4818.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 17:46 -0700, David Daney wrote:
> I have been playing around with trace-cmd and kernelshark on mips64
> and have encountered a couple of crashes.
> 
> These two patches fix the crashes.  But what is slightly less clear, is
> if they may cause valid trace events to be omitted. I don't think they do.
> 
> In any event here they are.
> 
> David Daney (2):
>   trace-cmd: Don't try to read unmapped memory (v2).
>   trace-cmd: Don't SIGSEGV in trace-graph.c:load_handle

Applied!

Thanks David,

-- Steve


