Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1EXSsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1EXSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:48:45 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vVy0PQ3ZQx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=j0-c7NIQ0P5GdHlv0DEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add a free on close control mechanism for
 buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <BANLkTikfyMEmQRsdkje64V0owZg2RsPpgQ@mail.gmail.com>
References: <1304106356-11277-1-git-send-email-vnagarnaik@google.com>
	 <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
	 <BANLkTikfyMEmQRsdkje64V0owZg2RsPpgQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 14:48:43 -0400
Message-ID: <1306262923.1465.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:37 -0700, Vaibhav Nagarnaik wrote:
> Hi Steven
> 
> Thanks for including my other patches in your tree. However, I did not
> see this patch included in it.
> 
> Did you want any changes to it?

There was a reason I didn't include this patch, but I don't remember
what it was ;)

I think I had to look at it deeper, but got too wrapped up in other
things, where as your other patches were easier to accept.

I'll try to get time to look at this patch in more depth again, and if
there's nothing wrong with it, I'll queue it up for my 2.6.41/2.8.1/3.1
queue.

It's too late to push it for this merge window.

Thanks,

-- Steve


