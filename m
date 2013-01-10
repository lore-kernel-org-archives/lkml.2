Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3AJQAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:00:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3AJP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:59:59 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UZaX57f3sdEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2-Qu8SYn35MA:10 a=h4sONjzpV4ywpKeYvAkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357833597.5141.5.camel@gandalf.local.home>
Subject: Re: [PATCH v3 39/44] metag: ftrace support
From: Steven Rostedt <rostedt@goodmis.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 10 Jan 2013 10:59:57 -0500
In-Reply-To: <1357831872-29451-40-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
	 <1357831872-29451-40-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 15:31 +0000, James Hogan wrote:

> --- /dev/null
> +++ b/arch/metag/kernel/ftrace.c
> @@ -0,0 +1,127 @@
> +/*
> + * Copyright (C) 2008 Imagination Technologies Ltd.
> + * Licensed under the GPL
> + *
> + * Dynamic ftrace support.
> + */
> +
> +#include <linux/ftrace.h>
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +#include <linux/ftrace.h>

duplicate <linux/ftrace.h>


> +
> +#include <asm/cacheflush.h>
> +
> +#define D04_MOVT_TEMPLATE	0x02200005
> +#define D04_CALL_TEMPLATE	0xAC200005
> +#define D1RTP_MOVT_TEMPLATE	0x03200005
> +#define D1RTP_CALL_TEMPLATE	0xAC200006
> +

The rest looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


