Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2B1Pio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:38:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2B1Pin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:38:43 -0500
Date: Tue, 28 Feb 2012 15:38:37 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: do not try to sanity test cover letters
Message-ID: <20120228153836.GL8110@shadowen.org>
References: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
 <1330389383.16334.22.camel@joe2Laptop>
 <CAP=VYLqnRXd_LR67+xz2k6YKX7YJiA7cgYwZ8pN3aQMgDN0dzw@mail.gmail.com>
 <1330390211.16334.24.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330390211.16334.24.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 04:50:11PM -0800, Joe Perches wrote:
> On Mon, 2012-02-27 at 19:47 -0500, Paul Gortmaker wrote:
> > On Mon, Feb 27, 2012 at 7:36 PM, Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2012-02-27 at 19:29 -0500, Paul Gortmaker wrote:
> > >> One possibly common workflow is this:
> > >>
> > >>       git format-patch -o mypatches --cover-letter ^start end
> > >>       ./scripts/checkpatch.pl mypatches/*
> > >
> > > I use a script for this and don't put the check
> > > in checkpatch but put the check in bash.
> > 
> > Sure, and I can do the same.  But my question to you is whether
> > you think the above is a common workflow, and if the false positives
> > that it generates will decrease the number of people likely to make
> > using it a part of their routine?
> 
> Dunno.  I generally think that tools should report
> errors when the input given them is inappropriate.

Tend to agree, the more complex we make checkpatch the more often it
will be wrong.  And it is wrong enough already.

-apw
