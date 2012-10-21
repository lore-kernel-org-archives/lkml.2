Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2JUQ24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:28:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60862 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2JUQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:28:55 -0400
Date: Sun, 21 Oct 2012 18:28:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 6/6] perf stat: implement --big-num grouping
Message-ID: <20121021162850.GD27429@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-7-git-send-email-irina.tirdea@gmail.com>
 <20121016164928.GB8020@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016164928.GB8020@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Oct 16, 2012 at 02:33:40AM +0300, Irina Tirdea wrote:
> > From: Irina Tirdea <irina.tirdea@intel.com>
> > 
> > In glibc, printf supports ' to group numbers with thousands' 
> > grouping characters. Bionic does not support ' for printf.
> > 
> > Implement thousands's grouping for numbers according to 
> > locale. The implementation uses the algorithm from glibc 
> > (http://www.gnu.org/software/libc/).
> > 
> > Bionic does not implement locales, so we need to add a 
> > configuration option LOCALE_SUPPORT. If it is not defined, 
> > default values for thousands separator and grouping are 
> > used.
> 
> Duplicating this in perf sounds like a hack. [...]

There's countless utility and compatibility 'hacks' in the Linux 
kernel too, which makes it a practical solution.

> [...] Does gnulib provide this feature?  It's the canonical 
> source for getting standards or helper functions on systems 
> that don't support them.

Unless Android comes with "gnulib" installed by default that's 
obviously not a solution.

What's your point?

Thanks,

	Ingo
