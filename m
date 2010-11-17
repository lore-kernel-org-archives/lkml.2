Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab0KQNFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:05:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43847 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0KQNFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nmVUZG4jmXd8A4XdMloI7Jqj5DAVsuhdGCHLgjUzLYePUpBNIQCl2QpfgHlDQLfM+Z
         FDv5uNL+pmGC3boIi13T7lkzvBy/RWKQOKENeM5paCaaG6Al+YC8o3sUsDN/TfVCirEj
         UXCudUg9MbrnQvaLOIyAwzfEshB9OZmB585Ik=
Date: Wed, 17 Nov 2010 15:05:16 +0200
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117150516.18136834@deb0>
In-Reply-To: <1289998312.2109.745.camel@laptop>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	<20101117144758.38bf4f05@deb0>
	<1289998312.2109.745.camel@laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 13:51:52 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-11-17 at 14:47 +0200, Török Edwin wrote:
> > I see --call-graph in the trace record -h output, but it doesn't
> > seem to work on x86_64 for me.
> 
> If you want to unwind userspace you need to build everything with
> framepointers -- sadly some people have been lobbying to remove
> framepointers from all distro builds, even though on x86_64 its nearly
> free (i386 does have a significant performance benefit, sadly).
> 
> There's some work on-going to simply copy out the top of stack and let
> dwarves go wild at it in userspace, but that isn't done yet.

Even without frame-pointers I should see at least the first caller in
userspace, since that can be obtained by reading the return address of
the syscall, right?
I don't see any difference in the output of 'trace report' thats why
I'm asking it is implemented at all right now, or I need additional
flags to see it.

I do see some difference in output of 'perf record -g/perf report'
though.

Best regards,
--Edwin


