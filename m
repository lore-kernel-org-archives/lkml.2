Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab0EZAzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:55:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EZAzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:55:47 -0400
Date: Tue, 25 May 2010 21:55:31 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
Message-ID: <20100526005531.GA9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
 <AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 25, 2010 at 11:08:29PM +0200, Stephane Eranian escreveu:
> On Mon, May 24, 2010 at 3:31 AM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Arnaldo Carvalho de Melo (2):
> >  perf report: Support multiple events on the TUI
> >  perf annotate: Fix up usage of the build id cache

> With these patches, can I analyze a binary on a remote
> machine? If I copy perf.data + .debug subdir, then can
> I run perf annotate on a different machine, where I don't
> have the sampled binaries installed?

It should, either directly thru 'perf annotate foo_symbol' or via the
TUI 'perf report' browser.
 
> I have tried that today using -tip, and perf annotate still
> looked for the binary using its original pathname in perf.data.
> perf report worked fine.

Can you please try it with -vvvv and make the output available
somewhere?

- Arnaldo
