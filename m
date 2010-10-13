Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0JMPDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:03:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57165 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0JMPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mtPlgYSsZCm6R9TZSLSzqtjd7MeHc5y8rNdnB8oXz8ffLzQoQNRc3Wr03Cg0QUd+YX
         ct9G5mngbNSt8K1DDGYQ0JpHB2kxDdglwKiVH/oJL4CllyeT/eWuCfAvkhEDFhxg7gAW
         5nUSfVDKKCIzO/aLzwpH+ULZQ5QCphN3UqoXg=
Date: Wed, 13 Oct 2010 17:02:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC PATCH 4/9] perf: Don't record frame pointer based user
	stacktraces if we dump stack and regs
Message-ID: <20101013150246.GF5335@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-5-git-send-regression-fweisbec@gmail.com> <1286954586.29097.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286954586.29097.60.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:23:06AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> > User and kernel stack might be selected for other uses than callchain
> > in the future, this probably shouldn't mess with the regular callchain
> > code. Instead we should probably have an exclude_callchain_user
> > attribute, that could be also useful to filter out user callchains
> > when people don't want them. 
> 
> Probably ;-)


Will change that then :)

Thanks.

