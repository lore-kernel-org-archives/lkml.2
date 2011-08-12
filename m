Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1HLNRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:17:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1HLNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:17:19 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=ygIOiH7ERsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ZgFp7YonpwMXfGFLYn0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] kmemleak: Show where early_log issues come from
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110812094018.GA1639@e102109-lin.cambridge.arm.com>
References: <1311701636.3526.97.camel@gandalf.stny.rr.com>
	 <20110812094018.GA1639@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 09:17:17 -0400
Message-ID: <1313155037.18583.321.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 10:40 +0100, Catalin Marinas wrote:

> Thanks for the patch, it makes sense. I was wondering whether we should
> extend the above to the other early kmemleak API calls (apart from
> KMEMLEAK_ALLOC). Also, to avoid some code duplication, maybe something
> like below:
> 

Makes sense to me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> +
> +		if (ret < 0)
> +			print_log_stack(log);
>  	}
>  }
>  
> 
> Thanks.
> 


