Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2CJKxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 05:53:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2CJKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 05:53:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4
Date: Sat, 10 Mar 2012 10:53:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Rob Herring <robherring2@gmail.com>
References: <201203092155.04731.rjw@sisk.pl> <201203092203.49812.arnd@arndb.de> <201203092327.00228.rjw@sisk.pl>
In-Reply-To: <201203092327.00228.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203101053.42926.arnd@arndb.de>
X-Provags-ID: V02:K0:bqe/q5o2SL04rsYTGeE2F2SEIiZIt+oO+GCXF2GiwUu
 CfBfsf6cOgb0qSk8OcctIeEV/++zhMMMygu4vbmGTYGZ+zXKNK
 4iouHCmWxd7ffHnjS/fqqaEWbcV6teUL6d/Q6u3DOUSLv9wtux
 L6IQq90fqQPThCQRMo6ggC+3TN8zfm29JH545WLoKRdfA1AdOT
 jg4FOALX4goG+eJPDd1r2Oo28c/XNfo8dqQRwFcgAGtyImYBR6
 d05HGzrsDaQOi7NEZGStpmVuwc3IabdmHj3T2aX/+DDI+qRq9w
 hC3aVAeL9O+tRqJ4Ih0EEtj9cJlsk0D0QCqKi09tbP8Lw59dXG
 yk7lviIsRbsoJcZVwLMA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2012, Rafael J. Wysocki wrote:
> On Friday, March 09, 2012, Arnd Bergmann wrote:
> > On Friday 09 March 2012, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Friday, March 09, 2012, Arnd Bergmann wrote:
> > > > On Friday 09 March 2012, Rafael J. Wysocki wrote:
> > > > > Hi,
> > > > > 
> > > > > Please pull Renesas SoC updates for v3.4 since commit
> > > > > ce8fea7aa4ad9e3b40999a08622ef27c77159659:
> > > > > 
> > > > >     mmap: EINVAL not ENOMEM when rejecting VM_GROWS
> > > > > 
> > > > > with top-most commit f57fd2100e8273af3a9d2ff67714903d2dfd1eef
> > > > 
> > > > Hi Rafael,
> > > > 
> > > > Please rebase this on an -rc release, otherwise we get a rather
> > > > messy history in the arm-soc tree.
> > > 
> > > Well, OK, I can rebase it on -rc7 if there is one, unless Paul
> > > has already pulled from clk_ops-rename.  Paul?
> > 
> > Why not rebase back to -rc6?
> 
> Well, I can do that too, if I have to, but still I'd like to be sure that
> Paul hasn't pulled from the clk_ops-rename branch yet.

The point is that there might not be an -rc7 any more. I'd suggest that
you rebase on -rc6 if Paul has not yet pulled them, otherwise we will
merge them in the current state and put an explanation into the merge
changeset.

	Arnd
