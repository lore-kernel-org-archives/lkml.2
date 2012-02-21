Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2BUAo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:44:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2BUAo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:44:57 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=lebwanUlCWQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=oGMlB6cnAAAA:8 a=FO1h9JXb5F29zexSvyAA:9 a=PUjeQqilurYA:10 a=CY6gl2JlH4YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329785094.25686.46.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Specify a size for the cmp in the
 NMI handler
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 20 Feb 2012 19:44:54 -0500
In-Reply-To: <CA+55aFywfyiLAWgp9ohMokrXFc-q7SLYMZtTunSpC_MO2dut3Q@mail.gmail.com>
References: <1329781367.25686.45.camel@gandalf.stny.rr.com>
	 <d3bc5132-98b4-485b-b400-5046350b7ccf@email.android.com>
	 <CA+55aFywfyiLAWgp9ohMokrXFc-q7SLYMZtTunSpC_MO2dut3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 16:11 -0800, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 4:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > You can use cmpl here... the segment is only a 16-bit number.  Or use testb $3,...
> 
> Yeah. And cmpl is one byte shorter (and the same size as testb).

I'll rebase and send again.

Thanks,

-- Steve


