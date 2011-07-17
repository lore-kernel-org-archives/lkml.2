Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1GQR3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 13:29:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48423 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1GQR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 13:29:44 -0400
Date: Sun, 17 Jul 2011 19:29:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 1/6] [BUGFIX] perf script: print correct IP
 address
Message-ID: <20110717172937.GA29355@somewhere>
References: <20110717093031.3447.52715.stgit@linux3>
 <20110717093045.3447.27199.stgit@linux3>
 <4E2306DE.4020109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2306DE.4020109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 09:59:26AM -0600, David Ahern wrote:
> On 07/17/2011 03:30 AM, Akihiro Nagai wrote:
> > perf_session_print_ip() prints addr_location->addr as IP address.
> > It's not always same as IP address. To correct it, this function
> > must print sample->ip.
> > 
> > Changes in v2:
> >  - add this patch
> 
> I submitted a patch for this back in May that was not picked up:
> https://lkml.org/lkml/2011/5/30/223
> 
> David

Oops, I'm going to bounce it to Peter / Ingo / Arnaldo...
