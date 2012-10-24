Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab2JXHtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626Ab2JXHtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:49:11 -0400
Date: Wed, 24 Oct 2012 09:49:04 +0200
From: Andrew Jones <drjones@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf header: Fix numa topology printing
Message-ID: <20121024074903.GA2227@turtle.usersys.redhat.com>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
 <1350999890-6920-1-git-send-email-namhyung@kernel.org>
 <20121023141218.GD2772@turtle.usersys.redhat.com>
 <874nlk9wxz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nlk9wxz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:00:08PM +0900, Namhyung Kim wrote:
> Hi Andrew,
> 
> On Tue, 23 Oct 2012 16:12:19 +0200, Andrew Jones wrote:
> > On Tue, Oct 23, 2012 at 10:44:49PM +0900, Namhyung Kim wrote:
> >> Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
> >> processed session env when printing") regresses the header output.
> >> It was because of a missed string pointer calculation in the loop.
> >
> > works for me
> >
> > Tested-by: Andrew Jones <drjones@redhat.com> 
> 
> Did you test both of the patches?

Yes, I applied both before testing. I'll add a tested by to the other
as well.

drew

> 
> Thanks,
> Namhyung
