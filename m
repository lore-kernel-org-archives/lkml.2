Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2GYRVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:21:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2GYRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:21:48 -0400
Date: Wed, 25 Jul 2012 19:21:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 14/17] perf, tool: Support for dwarf cfi unwinding on
 post processing
Message-ID: <20120725172140.GH1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-15-git-send-email-jolsa@redhat.com>
 <20120725170530.GE1173@somewhere.redhat.com>
 <20120725171655.GC17355@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725171655.GC17355@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:16:55PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 25, 2012 at 07:05:33PM +0200, Frederic Weisbecker escreveu:
> > > +#ifdef ARCH_X86_64
> > > +int unwind__arch_reg_id(int regnum)
> > 
> > Please try to avoid __ in function names. We used that convention
> > before but we gave up because that's actually more painful than
> > anything.
> 
> Well, I continue using it to separate the struct operated by the
> function from the function name.

As you prefer. I personally don't like it much because when I grep
for some function I have in mind, I stick on finding the right
underscore layout :)
