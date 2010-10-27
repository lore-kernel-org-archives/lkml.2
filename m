Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab0J0NgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:36:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab0J0NgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:36:06 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=HBrpTcUcxPYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=43p4ixcxx9vNNDb3uiEA:9 a=tZN6cZlgdoKfOT2tfXD19dqedjEA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] ftrace/MIPS: Enable C Version of recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, John Reiser <jreiser@bitwagon.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
In-Reply-To: <bb99009a9ac79d3f55a8c8bf1c8bd2bc0e1f160e.1288176026.git.wuzhangjin@gmail.com>
References: <cover.1288176026.git.wuzhangjin@gmail.com>
	 <bb99009a9ac79d3f55a8c8bf1c8bd2bc0e1f160e.1288176026.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 09:36:04 -0400
Message-ID: <1288186564.18238.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 18:59 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> Selects HAVE_C_RECORDMCOUNT to use the C version of the recordmcount
> intead of the old Perl Version of recordmcount.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

I'd like to get an Acked-by from Ralf and Maciej on this.

Thanks,

-- Steve

> ---
>  arch/mips/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 46cae2b..144e4b3 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -9,6 +9,7 @@ config MIPS
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
> +	select HAVE_C_RECORDMCOUNT
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES


