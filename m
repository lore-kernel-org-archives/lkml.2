Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030391Ab2HPTmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:42:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65294 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338Ab2HPTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:42:14 -0400
Date: Thu, 16 Aug 2012 16:42:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] perf ui/tui: Add tui.h header
Message-ID: <20120816194209.GB10277@infradead.org>
References: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
 <1345104894-14205-2-git-send-email-namhyung@kernel.org>
 <20120816193711.GA10277@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816193711.GA10277@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 16, 2012 at 04:37:11PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Aug 16, 2012 at 05:14:51PM +0900, Namhyung Kim escreveu:
> > Consolidate TUI-relate header files and declarations into tui.h.
> 
> What for?
> 
> #include directives should be used where they are needed, and in this
> new tui.h only the definitions of those two structs are needed, right?
> 
> I applied the first patch, looking at the others now.

Applied all the others too, testing now, should go to my perf/core
branch soon,

Thanks,

- Arnaldo
