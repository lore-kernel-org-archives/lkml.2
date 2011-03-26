Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1CZUtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:49:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36864 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab1CZUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=MyIAx+HFRldY3WGZGDWxaZamMlL7iFS1geykWqPSDuBGHzz+r51q+AH2XWboAmSjGj
         BFLhek9/8/Rc0i69dYy2g6l2+Zy7xOQizdFc4n9K3zMS5bb+w8KZjXc97jXwTBcZ/lVn
         BjMf4g4HIXxri36HgKa/yT/KCIiOphJLJx29k=
MIME-Version: 1.0
In-Reply-To: <1301062635.2250.212.camel@laptop>
References: <1300851416.31224.58.camel@minggr.sh.intel.com>
 <1301051277.2250.195.camel@laptop> <1301060121.2269.1.camel@localhost> <1301062635.2250.212.camel@laptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 26 Mar 2011 16:48:50 -0400
Message-ID: <AANLkTiktD6pqxNsy+9gXfKKRfooNxd2goLOwCP5-GRD8@mail.gmail.com>
Subject: Re: [RFC] perf: EBNF for event syntax
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:17, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Right, and as said changing this would create some backward compat
> problems so I'm not sure its the best proposal, just wanted to raise the
> issue that such functionality would be nice.

Not only nice, it's pretty much a requirement.  Most useful statistics
come in the form of ratios.  Collecting the values for ratios much
happen concurrently.  Currently perf isn't better than oprofile in
this respect.  One has to start perf separately for each ratio.
