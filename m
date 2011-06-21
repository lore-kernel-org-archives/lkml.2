Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1FUT1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:27:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab1FUT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:27:03 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=JXQmqsR9I0IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YWH8611o0T1Q-26ZiPcA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace-cmd: Add check for truncated files
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1308615578-556-1-git-send-email-vnagarnaik@google.com>
References: <1308615578-556-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Jun 2011 15:27:00 -0400
Message-ID: <1308684420.531.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 17:19 -0700, Vaibhav Nagarnaik wrote:
> If the trace data file that is being read is truncated, mmap'ing its
> non-existent page does not give any error. When the page is read, the
> process dies with a SIGBUS.
> 
> This patch adds a file size check while initializing the trace data and
> makes sure that the file size matches the expected size; otherwise an
> error is returned.

Thanks Vaibhav,

I'll queue this up.

-- Steve


