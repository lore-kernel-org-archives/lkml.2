Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2JMWAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 18:00:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2JMWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 18:00:54 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=__DW0lOuECQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=92jCHif2VFwA:10 a=LMtNXrtgceZqrz_fITwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350165651.24256.115.camel@gandalf.local.home>
Subject: Re: [PATCH 20/25] sparc: Use Kbuild infrastructure to handle
 asm-generic headers
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Date: Sat, 13 Oct 2012 18:00:51 -0400
In-Reply-To: <20121013.175400.1525893639346240797.davem@davemloft.net>
References: <20121013022955.307620438@goodmis.org>
	 <20121012.231941.1930318153077157651.davem@davemloft.net>
	 <1350136440.24256.95.camel@gandalf.local.home>
	 <20121013.175400.1525893639346240797.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 17:54 -0400, David Miller wrote:

> I really would like to take less rather than take more.
> 
> This whole UAPI, Kbuild, etc. stuff is just bogging subsystem
> maintainers down.  This kind of stuff should just go via the person
> who does all the work and knows how it all ties together and knows
> what dependencies, if any, exist in the series.
> 
> So please merge this yourself, thanks.

OK, will do.

-- Steve


