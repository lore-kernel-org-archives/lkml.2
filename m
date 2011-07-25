Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GYSZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:25:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1GYSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:25:48 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=FUKyzsEqjt0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=yoUXAZnbyWzfUL6WX1IA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Patch] fix a headers_check warning in include/linux/kernel.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>
In-Reply-To: <1311026457-23534-1-git-send-email-lacombar@gmail.com>
References: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
	 <1311026457-23534-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 14:25:46 -0400
Message-ID: <1311618346.3526.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 18:00 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> For the sake of having a patch ready. I actually did it yesterday but did not
> send it then. Cc'ed to the authors of the relevant macros; __FUNCTION__ was
> actually exported since ages, but I really do not see why the kernel exports
> this macros...
> 
>  - Arnaud
> 
> -- 
> From: Arnaud Lacombe <lacombar@gmail.com>
> Subject: linux/kernel.h: hide internal macros
> 
> Unexpose to userland the following macros
>  - BUILD_BUG_ON.*
>  - __FUNCTION__
>  - NUMA_BUILD
>  - COMPACTION_BUILD
>  - REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


