Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2C0N4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:56:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48259 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2C0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:55:59 -0400
Date: Tue, 27 Mar 2012 10:55:54 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
Message-ID: <20120327135554.GC5195@infradead.org>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
 <20120326173817.GN25820@infradead.org>
 <alpine.LFD.2.02.1203271337290.19635@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203271337290.19635@tux.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 27, 2012 at 01:44:42PM +0300, Pekka Enberg escreveu:
> I completely missed the newly added tools/perf/ui directory which doesn't 
> make much sense. We definitely ought to consolidate all this code under 
> tools/perf/util/ui and gradually move the tui code out of it instead.
> 
> [ I would, however, like to make the directory nesting less deep by 
>   dropping the "util" part from the directory name. But that's a 
>   completely different topic. ]

Yeah, the tools/perf/util/ should go away at some point, Borislav's
patches are a step in that direction, he is again at it, this time
carving out subsets so that we can go on gradually doing this
separation, see the tools top level Makefile discussion.

- Arnaldo
