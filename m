Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2GYRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab2GYRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:17:16 -0400
Date: Wed, 25 Jul 2012 14:16:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 14/17] perf, tool: Support for dwarf cfi unwinding on
 post processing
Message-ID: <20120725171655.GC17355@infradead.org>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-15-git-send-email-jolsa@redhat.com>
 <20120725170530.GE1173@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725170530.GE1173@somewhere.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 25, 2012 at 07:05:33PM +0200, Frederic Weisbecker escreveu:
> > +#ifdef ARCH_X86_64
> > +int unwind__arch_reg_id(int regnum)
> 
> Please try to avoid __ in function names. We used that convention
> before but we gave up because that's actually more painful than
> anything.

Well, I continue using it to separate the struct operated by the
function from the function name.

- Arnaldo
