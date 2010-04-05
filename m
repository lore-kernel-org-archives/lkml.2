Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0DEJ4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:56:52 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:49866 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0DEJ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:56:45 -0400
Message-ID: <4BB9B3CB.8010306@dcl.info.waseda.ac.jp>
Date: Mon, 05 Apr 2010 18:56:27 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf updates
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com> <20100404144223.GB5608@nowhere>
In-Reply-To: <20100404144223.GB5608@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/10 23:42, Frederic Weisbecker wrote:
 > On Sun, Apr 04, 2010 at 04:36:40PM +0200, Frederic Weisbecker wrote:
 >> Ingo,
 >>
 >> Please pull the perf/core branch that can be found at:
 >>
 >> 
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
 >> 	perf/core
 >>
 >> Thanks,
 >> 	Frederic
 >> ---
 >>
 >> Frederic Weisbecker (2):
 >>        perf: Drop the frame reliablity check
 >>        perf: Fetch hot regs from the template caller
 >>
 >> Arnd Bergmann (1):
 >>        perf_event: Make perf fd non seekable
 >>
 >> Hitoshi Mitake (1):
 >>        Swap inclusion order of util.h and string.h in util/string.c
 >
 >
 > I just did a last minute rebase, just to prepend the title of this
 > one with "perf: "

Ah, sorry, my naming of title was not good...

Thanks,
	Hitoshi
