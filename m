Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2ECNMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:12:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2ECNMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:12:30 -0400
Message-ID: <1336050734.22523.21.camel@twins>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 03 May 2012 15:12:14 +0200
In-Reply-To: <20120503130551.GA8115@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
	 <1335988003.13683.182.camel@twins> <20120502211805.GH5745@infradead.org>
	 <1336032100.13683.193.camel@twins> <20120503130551.GA8115@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 10:05 -0300, Arnaldo Carvalho de Melo wrote:
> > Also, in this case the asm is dark blue, which is nearly invisible on my
> > black background.
> 
> What colour do you suggest? Also what kind of term color scheme do you
> use? Finding the right default combo is kinda hard. 

Yeah, I know.. I use white text on black background.

Typically for vim I use :se bg=dark

Anyway, I find it weird that the asm is coloured completely different
between the two modes. If anything I would keep the asm as in the
non-source variant and when you add the source, make that a different
colour.

