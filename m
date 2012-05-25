Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2EYBcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:32:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2EYBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:32:24 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=uBGzXIQ1gwx6YJvmt1MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337909543.13348.227.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 24 May 2012 21:32:23 -0400
In-Reply-To: <4FBEC9E6.8040301@linux.intel.com>
References: <20120524160146.GA6226@redhat.com>
	  <1337876398.13348.178.camel@gandalf.stny.rr.com>
	  <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 16:53 -0700, H. Peter Anvin wrote:

> Waitaminute... this isn't related to your using R12 to save a pointer to
> something, is it?

We talked about using r12, but that patch hasn't made it out into the
wild yet. I haven't even pushed it into git yet. It still lives on a
quilt queue. Unless someone else abused r12, it wasn't from what I was
going to use it for.

-- Steve

> 
> > [ 1013.459871] RSP: ffffffff8165e919:ffff88014780f408  EFLAGS: 00010046
> 
> 	-hpa


