Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0GUPBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:01:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GUPBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:01:05 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=JRgKD5dZpGcA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7mOBRU54AAAA:8 a=fXnI7_GWgXXXpk8hGkEA:9 a=vlqw-0vrHuHe4mSO6iLPisafJHUA:4 a=PUjeQqilurYA:10 a=WeOa-AV5lc8A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing/documentation: document dynamic ftracer
 internals
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1279610015-10250-1-git-send-email-vapier@gentoo.org>
References: <1279610015-10250-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Jul 2010 11:01:04 -0400
Message-ID: <1279724464.4818.44.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, 2010-07-20 at 03:13 -0400, Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> your presentations helped to clarify a bit more what the dynamic code
> actually was doing.  the ifdef mess and multiple runtime patching locs
> were throwing me off before.

Thanks!

> 
> after experimenting with the Blackfin dynamic ftrace port under a simulator,
> this is what i think ive figured out.  please double check my assumptions.
> 
> btw, nice presentation at ols.  hope i didnt harass you too much ;).
> 
>  Documentation/trace/ftrace-design.txt |  153 +++++++++++++++++++++++++++++++-
>  include/linux/ftrace.h                |    5 +
>  2 files changed, 153 insertions(+), 5 deletions(-)

Looks good, I pulled it into my queue for 2.6.36.

-- Steve


