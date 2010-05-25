Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0EYDRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 23:17:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0EYDRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 23:17:48 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=XV6w7ZIvZjEA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=hGzw-44bAAAA:8 a=nS4V_YexDjHPEOnlBykA:9 a=TDqn0vOD8D6qS-xJ91wA:7 a=Qj-LUuIXVLtCqEgumlviEjztE9YA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=dowx1zmaLagA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing, powerpc: Add data parameter to
 powerpc-specific tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100524052735.GB10628@drongo>
References: <20100524052735.GB10628@drongo>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 24 May 2010 23:17:46 -0400
Message-ID: <1274757466.22648.203.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 15:27 +1000, Paul Mackerras wrote:
> Commit 38516ab5 ("tracing: Let tracepoints have data passed to
> tracepoint callbacks") added a void *data parameter to tracing
> callbacks and to the {un,}register_trace_* functions, requiring all
> tracepoint callback functions to have the extra void * parameter.
> 
> This adds the void *data parameter to the tracepoints in the pSeries
> hypervisor call code.  Without this, hvCall_inst.c fails to compile
> with tracing enabled.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

-- Steve

> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/platforms/pseries/hvCall_inst.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/hvCall_inst.c b/arch/powerpc/platforms/pseries/hvCall_inst.c
> index 1fefae7..9d03ef5 100644
> --- a/arch/powerpc/platforms/pseries/hvCall_inst.c
> +++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
> @@ -102,7 +102,8 @@ static const struct file_operations hcall_inst_seq_fops = {
>  #define CPU_NAME_BUF_SIZE	32
>  


