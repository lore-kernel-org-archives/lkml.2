Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0JMO6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:58:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46797 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0JMO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UAx8cOOCnDtAB2JU3/OIyfoUGBz9Mco4i0O0othRDEYsPD7j1LwSOogyfk9A+wLU2l
         A2Z2t18RG5rPX3QNc6vkbbCfs/tMkG6t1jJkKsfAFjkoJH8TcuOxwzeZQ5zvpIMyVq9f
         h0Ne+ID3BAbBFLSHkASOWoZuTc4ABIY95IpsY=
Date: Wed, 13 Oct 2010 16:58:00 +0200
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
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
Message-ID: <20101013145757.GD5335@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-3-git-send-regression-fweisbec@gmail.com> <1286954453.29097.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286954453.29097.58.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:20:53AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> > Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
> > user space context as it was before the user entered the kernel for
> > whatever reason.
> > 
> > This is going to be useful to bring Dwarf CFI based stack unwinding
> > on top of samples.
> 
> This doesn't address any of the issues that were raised previously.
> 
> There's a reason we don't have PERF_SAMPLE_*REGS like things.
> 
> See: http://lkml.org/lkml/2010/3/3/308


But the best would be to get it from sysfs I think.

