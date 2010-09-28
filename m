Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab0I1B6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:58:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0I1B6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:58:47 -0400
X-Authority-Analysis: v=1.1 cv=DXcwXsiCy0m6dtfuzmckRBGBU5A53VFijNRGSYZIu9o= c=1 sm=0 a=Zf2-li83EnIA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SABkXUh7u2RuocRKMEsA:9 a=Yzc_bzAWWu6s1ntbYnoA:7 a=ib8GVBUr-X8WMMz2NN_uLqzsvKQA:4 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Oops in trace_hardirqs_on (powerpc)
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20100927125037.GA4497@alea.gnuu.de>
References: <20100806233157.GA7117@alea.gnuu.de>
	 <1285184671.26872.127.camel@gandalf.stny.rr.com>
	 <20100927125037.GA4497@alea.gnuu.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 21:58:14 -0400
Message-ID: <1285639094.2989.1.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 14:50 +0200, Jörg Sommer wrote:
> Hello Steven,
> 
> Steven Rostedt hat am Wed 22. Sep, 15:44 (-0400) geschrieben:
> > Sorry for the late reply, but I was on vacation when you sent this, and
> > I missed it while going through email.
> > 
> > Do you still have this issue?
> 
> No. I've rebuild my kernel without TRACE_IRQFLAGS and the problem
> vanished, as expected. The problem is, that in some cases the stack is
> only two frames deep, which causes the macro CALLER_ADDR1 makes an
> invalid access. Someone told me, there a workaround for the problem on
> i386, too.
> 
> % sed -n 2p arch/x86/lib/thunk_32.S
>  * Trampoline to trace irqs off. (otherwise CALLER_ADDR1 might crash)

Yes, I remember that problem. When I get back from Tokyo, I'll tried to
remember to fix it.

Thanks!

-- Steve


