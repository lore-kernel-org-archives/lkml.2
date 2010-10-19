Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab0JSMp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:45:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0JSMp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:45:57 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=QR7Z30341-IA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ImOyRZdbylXH_Pju1dcA:9 a=BKtkCc6f8KoyzNNqJ2k9mI5xYZ4A:4 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/7] [GIT PULL] tracing: various updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101019071103.GA11443@elte.hu>
References: <20101018202939.828061748@goodmis.org>
	 <20101019062359.GB21782@elte.hu>  <20101019071103.GA11443@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 08:45:55 -0400
Message-ID: <1287492355.16971.361.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 09:11 +0200, Ingo Molnar wrote:
> hm, it doesnt build with certain configs:
> 
>  kernel/trace/trace_sched_wakeup.c:507: error: implicit declaration of function ‘start_func_tracer’
>  kernel/trace/trace_sched_wakeup.c:520: error: implicit declaration of function ‘stop_func_tracer’
> 
> Config attached.

Thanks, I'll take a look.

-- Steve


