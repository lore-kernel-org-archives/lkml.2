Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1BWPKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:10:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:44522 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1BWPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:10:53 -0500
Date: Wed, 23 Feb 2011 12:10:40 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/core TUI live annotate and a cleanup
Message-ID: <20110223151040.GD12398@ghostprotocols.net>
References: <1298400790-29453-1-git-send-email-acme@infradead.org>
 <20110223072842.GC15175@elte.hu>
 <1298446517.7856.143.camel@marge.simson.net>
 <1298471545.7846.17.camel@marge.simson.net>
 <20110223145026.GA20686@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223145026.GA20686@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 23, 2011 at 03:50:26PM +0100, Ingo Molnar escreveu:
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Works spiffy, and no lockup troubles (didn't get back to that, koff),
> > much nicer than the old annotation.  I did notice that pressing left
> > arrow one too many times leads to exit, dunno if that's intended.
> 
> I think it should at least ask for confirmation. Exiting on 'q' or escape 
> immediately would be fine.

Right, I'll get the code used in 'perf report' TUI to top, matching the
experiences.

- Arnaldo
