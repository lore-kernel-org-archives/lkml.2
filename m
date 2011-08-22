Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1HVJDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:03:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:33521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1HVJDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:03:44 -0400
Subject: Re: [PATCH -tip v3 2/5] perf: change perf_event_header.misc to
 PERF_RECORD_MISC_USER for BTS
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Date: Mon, 22 Aug 2011 11:02:51 +0200
In-Reply-To: <4E4B253B.4000703@hitachi.com>
References: <20110811120555.5900.23642.stgit@linux3>
	  <20110811120620.5900.50427.stgit@linux3> <1313065126.7144.6.camel@twins>
	 <4E4B253B.4000703@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314003771.24275.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 11:19 +0900, Akihiro Nagai wrote:
> > So what's wrong with something like:
> >
> >       header.misc |= is_kernel_address(at->from) ?
> >                       PERF_RECORD_MISC_KERNEL :
> >                       PERF_RECORD_MISC_USER;
> >
> It looks good.
> However, current perf doesn't output "kernel to kernel" BTS records.
> So, it is unnecessary yet.
> 
Ah, right, I thought we cured that at some point, ok all clear now.
