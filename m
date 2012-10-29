Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab2J2PSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:18:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab2J2PSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:18:00 -0400
Subject: Re: [PATCH 1/2] perf header: Fix numa topology printing
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Jones <drjones@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20121024074903.GA2227@turtle.usersys.redhat.com>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
	 <1350999890-6920-1-git-send-email-namhyung@kernel.org>
	 <20121023141218.GD2772@turtle.usersys.redhat.com>
	 <874nlk9wxz.fsf@sejong.aot.lge.com>
	 <20121024074903.GA2227@turtle.usersys.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Oct 2012 00:17:54 +0900
Message-ID: <1351523874.1617.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-24 (수), 09:49 +0200, Andrew Jones:
> On Wed, Oct 24, 2012 at 04:00:08PM +0900, Namhyung Kim wrote:
> > On Tue, 23 Oct 2012 16:12:19 +0200, Andrew Jones wrote:
> > > On Tue, Oct 23, 2012 at 10:44:49PM +0900, Namhyung Kim wrote:
> > >> Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
> > >> processed session env when printing") regresses the header output.
> > >> It was because of a missed string pointer calculation in the loop.
> > >
> > > works for me
> > >
> > > Tested-by: Andrew Jones <drjones@redhat.com> 
> > 
> > Did you test both of the patches?
> 
> Yes, I applied both before testing. I'll add a tested by to the other
> as well.

Arnaldo, I think these two should go through the urgent branch.  Would
you apply them?

Thanks,
Namhyung


