Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0HQQjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:39:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40282 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0HQQjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:39:19 -0400
Date: Tue, 17 Aug 2010 17:39:15 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts: checkpatch.pl
Message-ID: <20100817163915.GN6193@shadowen.org>
References: <1277286561-3448-1-git-send-email-lamiaposta71@gmail.com>
 <1277286561-3448-2-git-send-email-lamiaposta71@gmail.com>
 <20100623122759.7bf304e6.akpm@linux-foundation.org>
 <AANLkTimYibiMB0wx2LSvj8InY_SSvBcO3AiH-0jdT8OG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYibiMB0wx2LSvj8InY_SSvBcO3AiH-0jdT8OG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 08:27:30AM +0200, Raffaele Recalcati wrote:
> 2010/6/23 Andrew Morton <akpm@linux-foundation.org>
> 
> > On Wed, 23 Jun 2010 11:49:21 +0200
> > Raffaele Recalcati <lamiaposta71@gmail.com> wrote:
> >
> > > From: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> > >
> > > I've got a false positive when spaces are present
> > > at the beginning of a line.
> > > So I add this check, obviously outside comments.
> > > This patch is compatible with the actual mainline,
> > > I mean 7e27d6e778cd87b6f2415515d7127eba53fe5d02 commit.
> >
> > I don't really understand that.  It would help if the changelog
> > were to include a copy of the code which triggers this "false
> > positive", and a copy of the incorrect checkpatch.pl output.
> >
> > Thanks.
> >
> >
> Would be nice a changelog like this?
> 
> ----start changelog-----------
> I've got a false positive when spaces are present at the beginning of a
> line.
> So I add this check, obviously excluding to check the lines in the middle of
> comments.

This check seems to be causing regressions for valid combinations.  I
have a patch to this patch which seems to fix it, I am currently fixing
the test suite and test it generally.

Andrew, will get the delta up to you shortly.

-apw
