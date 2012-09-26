Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2IZB2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:28:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2IZB2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:28:38 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=b9PsUg4mK9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=TSMuYQ0iYaAA:10 a=6LM_PC-HNDL-7sbMh5kA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348622916.22822.44.camel@gandalf.local.home>
Subject: Re: [PATCH v5 0/25] Generic Red-Black Trees (still WIP)
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 25 Sep 2012 21:28:36 -0400
In-Reply-To: <50625436.1020501@att.net>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
	 <1348618742.22822.39.camel@gandalf.local.home> <50625436.1020501@att.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 20:02 -0500, Daniel Santos wrote:
> >> Q&A
> >> ===
> >> Q: Why did you add BUILD_BUG_ON_NON_CONST() and
> >>    BUILD_BUG_ON_NON_CONST42()?
> > A: Because BUILD_BUG_ON_NON_CONST42() will crash if it does not result
> > in the answer to life, the universe and everything!
> 
> By the way, I have a theory before time, God was writing code on some
> cosmic computer (beyond our understanding, of course) when he
> accidentally tried to divide by zero, resulting in a core dump that we
> now know as the universe we live in.  So thus, we are just the excrement
> of some celestial computer after it failed to properly execute its code.
> 

And that operation on which God failed on was:

ans = 42 / 0

Which totally explains the point where... "to understand the answer, you
must first understand the question".

-- Steve

