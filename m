Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2B1AuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:50:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49656 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753965Ab2B1AuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:50:12 -0500
Message-ID: <1330390211.16334.24.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: do not try to sanity test cover letters
From: Joe Perches <joe@perches.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 16:50:11 -0800
In-Reply-To: <CAP=VYLqnRXd_LR67+xz2k6YKX7YJiA7cgYwZ8pN3aQMgDN0dzw@mail.gmail.com>
References: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
	 <1330389383.16334.22.camel@joe2Laptop>
	 <CAP=VYLqnRXd_LR67+xz2k6YKX7YJiA7cgYwZ8pN3aQMgDN0dzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 19:47 -0500, Paul Gortmaker wrote:
> On Mon, Feb 27, 2012 at 7:36 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2012-02-27 at 19:29 -0500, Paul Gortmaker wrote:
> >> One possibly common workflow is this:
> >>
> >>       git format-patch -o mypatches --cover-letter ^start end
> >>       ./scripts/checkpatch.pl mypatches/*
> >
> > I use a script for this and don't put the check
> > in checkpatch but put the check in bash.
> 
> Sure, and I can do the same.  But my question to you is whether
> you think the above is a common workflow, and if the false positives
> that it generates will decrease the number of people likely to make
> using it a part of their routine?

Dunno.  I generally think that tools should report
errors when the input given them is inappropriate.

cheers, Joe

