Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab1DYPjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:39:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1DYPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:39:46 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=leM7PVNcp3QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=uNeeGYA1Z7-LsK4tVaYA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add tracepoints to fs subsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <20110425113723.2666.A69D9226@jp.fujitsu.com>
References: <1303513209-26436-1-git-send-email-vnagarnaik@google.com>
	 <20110425113723.2666.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Apr 2011 11:39:45 -0400
Message-ID: <1303745985.18763.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 11:35 +0900, KOSAKI Motohiro wrote:
> > From: Jiaying Zhang <jiayingz@google.com>
> > 
> > Many fs tracepoints can now be traced via ftrace, however there are a
> > few other tracepoints needed. This patch adds entry and exit tracepoints
> > for a few additional functions, viz.:
> > wait_on_buffer
> > block_write_full_page
> > mpage_readpages
> > file_read
> 
> Zero background description?
> 

Good point.

Could you please describe how this is useful, and how one can benefit
from these tracepoints.

-- Steve



