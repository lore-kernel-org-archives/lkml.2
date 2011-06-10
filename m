Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1FJD7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:59:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1FJD66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
 <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 20:57:45 -0700
Message-ID: <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> For the record, this should have been fixed by Michal in:

You're missing the problem: we can't assume that people have updated user land.

Furthermore, the very pull request I'm responding to actually tries to
handle this, see commit bfe5424a8b31 ("kbuild: Hack for depmod not
handling X.Y versions"), but it's just not working for me.

And it's not working, because it only handles the "modules_install"
case, not the case where the system install scripts do their own
depmod.

                       Linus
