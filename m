Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2A0Vrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:47:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2A0Vrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:47:36 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=JdVoL3hd7TAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=hK5XsNzSdRvcdbDsc-cA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327700854.22710.145.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/5] jump labels/x86: Use etiher 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Jan 2012 16:47:34 -0500
In-Reply-To: <20120127202032.323768805@goodmis.org>
References: <20120127201442.080360013@goodmis.org>
	 <20120127202032.323768805@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 15:14 -0500, Steven Rostedt wrote:
> +static unsigned char nop_short[] = { P6_NOP2 };
> +
> +/* These are the nops added at compile time */
> +static unsigned char default_nop[] = { JUMP_LABEL_INIT_NOP };
> +
> 
Andrew,

I also made the above two into static const. Just so you know ;-)

-- Steve


