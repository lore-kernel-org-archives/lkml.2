Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2A0UmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:42:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2A0UmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:42:02 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=EFLXiCCoQusA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=yNpAF3D4zaanTAVe4XIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327696921.22710.132.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/5] x86/jump-label: Do not bother updating nops if they
 are correct
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Jan 2012 15:42:01 -0500
In-Reply-To: <20120127123437.481791ba.akpm@linux-foundation.org>
References: <20120127201442.080360013@goodmis.org>
	 <20120127202031.234193929@goodmis.org>
	 <20120127123437.481791ba.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 12:34 -0800, Andrew Morton wrote:

> > +	if (!once) {
> > +		unsigned char default_nop[] = { JUMP_LABEL_INIT_NOP };
> 
> const.  It generates less code.  With my compiler version, at least. 
> That was a bit dumb of it, given that memcmp() is declared to take
> const args.

OK will update,

Thanks!

-- Steve



