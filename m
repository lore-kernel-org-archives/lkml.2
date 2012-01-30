Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2A3SWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:22:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45499 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2A3SWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:22:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120130174345.GN4882@opensource.wolfsonmicro.com>
References: <20120130134223.GG4882@opensource.wolfsonmicro.com>
 <CA+55aFyoTP3G_x9KzN_cdDYUxRGTBBdoRVT56nFODkqukog7aQ@mail.gmail.com> <20120130174345.GN4882@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Jan 2012 10:22:28 -0800
X-Google-Sender-Auth: UNx9_E8p6hGpC1z6GzIt-c7DMCs
Message-ID: <CA+55aFxPivRzaKaNnTseyWmRhfvxV1=gWSTzgmSZx5Nm8XK=zg@mail.gmail.com>
Subject: Re: Regulator update for 3.3
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 9:43 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
>> Forgot to push?
>
> Not quite, I had pushed a new signed tag but I hadn't deleted the old
> for-linus branch (which you had merged).  Since git prefers branches
> to tags when pulling it was looking at the old branch and ignoring the
> signed tag.  Should be cleaned up now, at least I deleted the branch and
> everything looks OK in gitweb.

Ok. You could also have asked me to pull "tags/for-linus" to
disambiguate. That has the advantage that I think it even works with
older versions of git - they'll get the tag, then ignore the tag
information, and do the merge of just the commit the tag points to.

> I actually noticed this with some other things I was doing, what I think
> I want git to do when working with signed tags is allow me to have a tag
> with the same name as the branch and prefer the tag rather than the
> branch.  That way I can tell people to pull from a given name and it'll
> do the right thing if they're using a git that understands pulling from
> tags or not.  Either that or complain bitterly and mock me if I'm so
> foolish as to have a tag and branch with the same name.

I won't mock you (*this* time), but I think the "tags/for-linus"
approach is better, as it should work regardless of git version.

                      Linus
