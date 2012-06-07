Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab2FGKb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:31:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51586 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2FGKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:31:58 -0400
Date: Thu, 7 Jun 2012 12:31:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120607103148.GF19842@somewhere.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
 <1337801535-12865-2-git-send-email-jolsa@redhat.com>
 <1337852636.9783.89.camel@laptop>
 <20120607094624.GB19842@somewhere.redhat.com>
 <1339064963.23343.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339064963.23343.16.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 12:29:23PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-07 at 11:46 +0200, Frederic Weisbecker wrote:
> > 
> > Do you think that compat regs are always a subset of native regs in all
> > archs as in x86? Sounds logic but I'm asking just in case. If so then yeah
> > this should work. 
> 
> I can't answer this authoritatively but it would seem strange if this
> were not the case. But even if it were so, you could always frob both
> sets in a single space such that the shared registers overlap etc. 

Looks good. Let's take that direction then.
