Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1CJNQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:16:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61320 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1CJNQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:16:09 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=KjT2LIUkuf4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=59qInKXrf230AuHHryYA:9 a=8HRfr5qkUf0nDLZBgLp1uVCrWE0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] trace-cmd: fold option parsing
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D78A0A9.40000@cn.fujitsu.com>
References: <4D78A0A9.40000@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 08:16:07 -0500
Message-ID: <1299762967.15854.335.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:58 +0800, Lai Jiangshan wrote:
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks!

>  
> +#define OPT_debug	255
> +

>  
> +#define OPT_cpu		255
> +#define OPT_events	254
> +#define OPT_kallsyms	253
> +

I wonder if it would look cleaner if we converted them all to enums:

enum {
	OPT_kallsyms	= 253,
	OPT_events	= 254,
	OPT_cpu		= 255,
};

As in the kernel, defines look ugly, and can have side-effects.

-- Steve


