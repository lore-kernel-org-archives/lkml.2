Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2LLQOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:14:21 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64582 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2LLQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:14:20 -0500
Date: Wed, 12 Dec 2012 13:14:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, namhyung.kim@lge.com
Subject: Re: [PATCH 1/4] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121212161413.GB2382@ghostprotocols.net>
References: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
 <1355128197-18193-2-git-send-email-namhyung@kernel.org>
 <20121210134434.GA6416@krava.brq.redhat.com>
 <20121212152926.GA2382@ghostprotocols.net>
 <20121212155632.GA1097@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212155632.GA1097@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 12, 2012 at 04:56:32PM +0100, Jiri Olsa escreveu:
> On Wed, Dec 12, 2012 at 12:29:26PM -0300, Arnaldo Carvalho de Melo wrote:
> > Got inverted.

> > The order was arbitrary, and was arbitrarily reversed, are you guys sure this
> > is the only side effect?

> right,

> currently (without namhyung's changes) there's initial 'name' sorting
> broken by hists_link

> after the change, it gets sorted 'but' there are dummy entries added
> which brake the sort again.. this is sorted out within the multi diff
> patches

> so the bottom line is that currently the sorting is broken anyway,
> and the fix is comming in upcomming patchset ;)

Ok, applied to my perf/core branch and pushed out.

> > Jiri, IIRC you mentioned that there would be some patch with an --order switch,
> > would that allow sorting by the entry that had the biggest change, etc?
> 
> by default it'll sorted by baseline and you can specify -o X to sort
> by specified file

great.

- Arnaldo
