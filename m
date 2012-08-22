Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2HVSyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:54:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47060 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2HVSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:54:03 -0400
Date: Wed, 22 Aug 2012 15:53:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] tools lib traceevent: Basic error handling
Message-ID: <20120822185356.GC13623@infradead.org>
References: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
 <877gsrie2s.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gsrie2s.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 22, 2012 at 04:24:43PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Wed, 22 Aug 2012 16:00:27 +0900, Namhyung Kim wrote:
> > I almost forgot that I have some libtraceevent patch left. ;)  The
> > first three of them are acked by Steven and the last is a port of a
> > recent perf patch from Kirill that handles a strerror_r build warning.
> > Please consider applying.
> 
> I also forgot that I didn't remove the Link: line from the changelogs
> before sending them, sorry.  Anyway, you can pull this series from my
> tree which contains libtraceevent/core branch, if you like (I added a
> Link to patch 4 there for your convenience).

This time around I'll get it manually since its a short patchset so as
to get the Acked-by Kirill

- Arnaldo
