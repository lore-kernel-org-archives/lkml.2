Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698Ab2EXTY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:24:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510Ab2EXTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:24:57 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=NUpDF50d_VZ6Gc1fbCUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337887495.13348.195.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 24 May 2012 15:24:55 -0400
In-Reply-To: <20120524191147.GA13936@redhat.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337880914.13348.189.camel@gandalf.stny.rr.com>
	 <20120524184728.GA13201@redhat.com>
	 <1337885672.13348.194.camel@gandalf.stny.rr.com>
	 <20120524191147.GA13936@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:11 -0400, Dave Jones wrote:

>  > Also, how reproducible is it? When it triggered for me, it was constant.
>  > Every boot and test failed. But after I did the make mrproper, I have
>  > not been able to trigger it again. This is why I put it down as a bad
>  > build.
> 
> happens every time for me so far.

Did you also do a make mrproper and try again?

-- Steve


