Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1EBMbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:31:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1EBMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:31:50 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=80hgNzRN3JIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QTMACBUuWtI_NLJJXYgA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 2 May 2011 08:31:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: werner <w.landgraf@ru.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jaxboe@fusionio.com,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110502123148.GA25265@home.goodmis.org>
References: <web-516397730@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-516397730@zbackend1.aha.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 03:09:14AM -0400, werner wrote:
> For make it more easy to see what potentially could be the reason
> for these problems, below is the difference in the config: between
> my everythingyes config (used since -git2), and the good working
> config based on Slw. huge-smp with more things disabled. If someone
> tell me what potentially could cause such problems, I can re-compile
> the kernel, disabling it.
> 

FYI,

There's a cool utility in the scripts directory called diffconfig. It
gives a much nicer output than doing a normal diff.

Thanks,

-- Steve

