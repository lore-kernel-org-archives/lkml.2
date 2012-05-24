Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2EXSyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:54:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2EXSye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:54:34 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=9czN0PM_2i_WrB6jP5cA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337885672.13348.194.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 24 May 2012 14:54:32 -0400
In-Reply-To: <20120524184728.GA13201@redhat.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337880914.13348.189.camel@gandalf.stny.rr.com>
	 <20120524184728.GA13201@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 14:47 -0400, Dave Jones wrote:
> On Thu, May 24, 2012 at 01:35:14PM -0400, Steven Rostedt wrote:
> 
>  > Hmm, I wonder if this is the break point change :-/
>  > 
>  > Do you have NMIs enabled? I didn't have 'paranoid_exit' in my backtrace
>  > when I saw the bug.
> 
> $ grep NMI .config
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HPWDT_NMI_DECODING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set

Could you email your entire config. I haven't been able to trigger the
bug again. Maybe your config might do it :-/

Also, how reproducible is it? When it triggered for me, it was constant.
Every boot and test failed. But after I did the make mrproper, I have
not been able to trigger it again. This is why I put it down as a bad
build.

-- Steve


