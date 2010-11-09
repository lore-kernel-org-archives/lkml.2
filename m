Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0KIOYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:24:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64327 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0KIOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:24:10 -0500
Subject: Re: [PATCH 6/6] ARM: ftrace: enable function graph tracer
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-arm-kernel@lists.infradead.org, Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20101109134644.GA3163@debian>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
	 <1289067954-5080-6-git-send-email-rabin@rab.in>
	 <AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
	 <20101108091858.GP16938@pengutronix.de>
	 <AANLkTinmSn1fqKv8sCCP8d0-_0HsLrhtorXvHCovOYve@mail.gmail.com>
	 <20101109134644.GA3163@debian>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 09 Nov 2010 14:22:53 +0000
Message-ID: <1289312573.11461.18.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2010 14:22:53.0829 (UTC) FILETIME=[98EB5B50:01CB8019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:46 +0000, Rabin Vincent wrote:
> Subject: [PATCHv2] ARM: ftrace: enable function graph tracer
> 
> Add the options to enable the function graph tracer on ARM.  Function
> graph tracer support requires frame pointers, so exclude Thumb-2 and
> also make sure FRAME_POINTER gets enabled when FUNCTION_GRAPH_TRACER is
> used, since FUNCTION_TRACER doesn't "select FRAME_POINTER" when
> ARM_UNWIND is used.  Therefore, with GCC 4.4.0+, you get plain function
> tracing without frame pointers, but you'll need them if you want
> function graph tracing.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Looks ok to me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

