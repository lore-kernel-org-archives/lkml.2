Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0KJTLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:11:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0KJTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q4mC2VjRFIvSWfSgZVasPkB9xytClOKg10IIAC3zj8Ttv9Ma67SShHy+G06orw/VW2
         uqu3bJ+XViE/wegsydX3VKP6bX/+cuXnNfHTTYOfBHrn+gvw0FKOl0GbPbLNA5I8pa25
         5s+lq8hDJuixy4jepuzApQmYwOoyl98WS/IfQ=
Date: Wed, 10 Nov 2010 20:11:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110191127.GA6190@nowhere>
References: <20101110101450.GA18481@elte.hu> <1289400056.12418.139.camel@gandalf.stny.rr.com> <1289400234.2191.129.camel@laptop> <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289415645.12418.180.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:00:45PM -0500, Steven Rostedt wrote:
> On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:
> 
> > We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
> > As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
> > and will do better here.
> 
> Thus you are saying that we stick to the status quo, and also ignore the
> fact that perf was a rewrite-the-world from ftrace to begin with.


Perhaps you and Mathieu can summarize your requirements here and then explain
why extending the current ABI wouldn't work. It's quite normal that people
try to find a solution fully backward compatible in the first place. If
it's not possible, fine, but then justify it.

