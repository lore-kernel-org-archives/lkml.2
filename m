Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0DNPL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:11:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab0DNPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:11:56 -0400
X-Authority-Analysis: v=1.1 cv=fBoeiQUdCPFYkf/ogivDuUUJ8T/GUdptomsnt0mqf60= c=1 sm=0 a=Lfq0IFdGML4A:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=gu6fZOg2AAAA:8 a=gEHSBOxwXaXEWl96V4oA:9 a=9xq5tSLqyWehZh7pIhwA:7 a=IbCiv3iGFbWtxMNSqqi0RUeE8OoA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/2] tracing: lost events changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
References: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 11:11:28 -0400
Message-ID: <1271257888.19099.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 15:00 +0200, Jiri Olsa wrote:
> hi,
> 
> I noticed LOST EVENTS messages in the iterator "trace" file.
> According to the comment from commit bc21b478 this won't work.
> 
> <comment>
>     Note, it does not work with the iterator "trace" file, since it requires
>     the use of consuming the page from the ring buffer to determine how many
>     events were lost, which the iterator does not do.
> </comment>
> 
> I'm not sure the attached fix (2/2) is on the right place,
> but stops the LOST EVENTS display for iterator "trace" file.
> 

This has already been fixed by Lai:

http://marc.info/?l=linux-kernel&m=127045871922996

And I asked Ingo to pull it here:

http://marc.info/?l=linux-kernel&m=127048065715829

> I also added option to control the LOST EVENTS display (1/2) if needed.

Hmm, I'm not sure we want to control it. It is very useful information.

Thanks,

-- Steve

> 
> attached patches:
> - 1/2 - adding lost-events option
> - 2/2 - supress lost events message for iterator "trace"
> 
> 
> wbr,
> jirka
> ---
>  kernel/trace/trace.c |   24 ++++++++++++++----------
>  kernel/trace/trace.h |    1 +
>  2 files changed, 15 insertions(+), 10 deletions(-)


