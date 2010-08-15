Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab0HOBPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 21:15:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46957 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0HOBPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 21:15:45 -0400
Date: Sun, 15 Aug 2010 03:15:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: sedat.dilek@gmail.com
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix savedefconfig with choice marked optional
Message-ID: <20100815011542.GA30094@merkur.ravnborg.org>
References: <AANLkTimYDzCowvmKgSDp0BJjLHadvtDgCVJkZgdAt4u7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYDzCowvmKgSDp0BJjLHadvtDgCVJkZgdAt4u7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 01:26:22AM +0200, Sedat Dilek wrote:
> Recent kbuild/kconfig patches seem not to be in
> <http://repo.or.cz/w/linux-kbuild.git>?
> 
> Looks like there is a new home:
> 
> -T:      git git://repo.or.cz/linux-kbuild.git for-next
> -T:      git git://repo.or.cz/linux-kbuild.git for-linus
> +T:      git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
> for-next
> +T:      git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
> for-linus

This is already fixed in upstream. You need to update
your source repository.

See: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3631d9a2e503ec9c36b0599b2e45548e5c410516

	Sam
