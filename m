Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab2FGK3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:29:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58241 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2FGK3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:29:48 -0400
Message-ID: <1339064963.23343.16.camel@twins>
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of
 arch registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Date: Thu, 07 Jun 2012 12:29:23 +0200
In-Reply-To: <20120607094624.GB19842@somewhere.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-2-git-send-email-jolsa@redhat.com>
	 <1337852636.9783.89.camel@laptop>
	 <20120607094624.GB19842@somewhere.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 11:46 +0200, Frederic Weisbecker wrote:
> 
> Do you think that compat regs are always a subset of native regs in all
> archs as in x86? Sounds logic but I'm asking just in case. If so then yeah
> this should work. 

I can't answer this authoritatively but it would seem strange if this
were not the case. But even if it were so, you could always frob both
sets in a single space such that the shared registers overlap etc. 
