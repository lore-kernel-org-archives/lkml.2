Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0FGVAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:00:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0FGVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:00:41 -0400
X-Authority-Analysis: v=1.1 cv=xm0otvE9/LjRWYlyDrHfx7zP0/MGCmNk7gQgTP1ehto= c=1 sm=0 a=M9mPRY19pikA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=rie4t3upTMFJl9bqew4A:9 a=m9XH2F1fnB8IUO4CFVS9UvrZfK4A:4 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v2][GIT PULL][v2.6.35] tracing/events: Convert format
 output to seq_file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <4C0CA681.5000100@jp.fujitsu.com>
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
	 <1275622026.15884.72.camel@gandalf.stny.rr.com>
	 <4C0CA681.5000100@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 07 Jun 2010 17:00:38 -0400
Message-ID: <1275944438.15884.92.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 16:57 +0900, Kei Tokunaga wrote:

> There's been an oversight...  Thanks a lot for finding and fixing
> this!  I built a kernel with the patch applied and confirmed the
> issue is fixed on my box.
> 
> Tested-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Thanks Kei!

> 
> >     Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> >     Cc: Martin K. Petersen <martin.petersen@oracle.com>
> >     Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> >     Cc: James Bottomley <James.Bottomley@suse.de>
> >     Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> >     Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> >

Ingo,

Can we get this into 35? Without this patch, the two new SCSI
tracepoints are useless for tracing (this includes perf trace).
Actually, the in kernel pretty-printing will still work fine without
this patch.

If you want, you can pull this patch in from email, and add Kei's
Tested-by tag too.

Thanks,

-- Steve


