Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2HZQKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:10:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:37699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2HZQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:10:30 -0400
Subject: Re: perf backtraces off-by-1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <5037FC9F.3090603@fb.com>
References: <5037FC9F.3090603@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Aug 2012 18:10:15 +0200
Message-ID: <1345997415.2296.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 15:13 -0700, Arun Sharma wrote:
> 
> Wondering if this has been discussed before.

Not that I can recall.

>  One option is to support 
> this for user mode only, with code to detect signal frames. Any other
> ideas?
> 
I guess we'd need to see what that patch would look like... :-)

