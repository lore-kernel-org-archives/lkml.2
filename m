Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab0LTVMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:12:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56143 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab0LTVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:12:11 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=Zf2-li83EnIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=32ND24gm9FxZJ7-16HEA:9 a=1Ek9_At_dJibNcgAmAyKXgIl2scA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Oops in trace_hardirqs_on (powerpc)
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <1292877806.22905.62.camel@gandalf.stny.rr.com>
References: <20100806233157.GA7117@alea.gnuu.de>
	 <1285184671.26872.127.camel@gandalf.stny.rr.com>
	 <20100927125037.GA4497@alea.gnuu.de> <1285639094.2989.1.camel@frodo>
	 <20101219132705.GE6615@alea.gnuu.de>
	 <1292877806.22905.62.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 16:12:09 -0500
Message-ID: <1292879529.22905.63.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 15:43 -0500, Steven Rostedt wrote:

> Anyway, it looks like this only affects 32 bit PPC as I can't reproduce
> it with my 64 bit one. And also, unfortunately, my 32bit ppc got taken
> from me by my kids, so I can't test it on that either.


Spoke too soon, I just triggered it on 64bit.

I'll look into it. Thanks!

-- Steve


