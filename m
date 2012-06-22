Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2FVKtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:49:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab2FVKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:49:03 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=-v9zWHfhjGwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=_gxSTfL8AAAA:8 a=t_bC-9rGgjebfDGWIZAA:9 a=PUjeQqilurYA:10 a=Sya1ZFHK3KgA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340362141.27036.228.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][RT] spinlock: Add include for BUG() in spinlock_rt.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        leroy christophe <christophe.leroy@c-s.fr>,
        Iratxo Pichel Ortiz <ipichel@albentia.com>,
        David Garcia <dgarcia@albentia.com>
Date: Fri, 22 Jun 2012 06:49:01 -0400
In-Reply-To: <alpine.LFD.2.02.1206221108180.2853@ionos>
References: <1340285878.27036.138.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1206221108180.2853@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 11:08 +0200, Thomas Gleixner wrote:
> On Thu, 21 Jun 2012, Steven Rostedt wrote:
> 
> > spinlock_rt.h references BUG(), but it does not include bug.h, and on
> > some architectures (powerpc) this can cause a build failure.
> > 
> > Reported-by: Iratxo Pichel Ortiz <ipichel@albentia.com>
> > Reported-by: leroy christophe <christophe.leroy@c-s.fr>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ----
> > [ Thomas, can you add this patch to your queue so that I can add it to
> > stable. Please, let me know when you have. Thanks! ]
> 
> Picked it up, thanks. Please take it right away w/o waiting for my
> release.
> 

I'll make a release today.

-- Steve


