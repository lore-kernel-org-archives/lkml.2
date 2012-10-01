Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab2JANm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:42:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2JANm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:42:28 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tWoi2GowG8EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=UU8HPSD0ZrcA:10 a=Dd5sLyAVgoUiyoPAJaYA:9 a=PUjeQqilurYA:10 a=Npcgo5jUSCZaSAEO:21 a=E1ayQoa4Mc379UFG:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349098945.22822.113.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Fix missed freeing of subargs in
 free_arg() in filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 01 Oct 2012 09:42:25 -0400
In-Reply-To: <1349097395.1613.4.camel@leonhard>
References: <1348874483.22822.100.camel@gandalf.local.home>
	 <1349097395.1613.4.camel@leonhard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 22:16 +0900, Namhyung Kim wrote:

> Although they have same layout, wouldn't it be better using their own
> fields?
> 
> 	case FILTER_ARG_NUM:
> 		free_arg(arg->num.left);
> 		free_arg(arg->num.right);
> 		break;
> 
> 	case FILTER_ARG_EXP:
> 		free_arg(arg->exp.left);
> 		free_arg(arg->exp.right);
> 		break;

Yeah, I got lazy. This is probably better. I'll resend.

Thanks,

-- Steve


