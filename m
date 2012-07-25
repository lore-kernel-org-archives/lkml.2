Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2GYNJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:09:05 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61502 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2GYNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120724192120.GB29239@thunk.org>
References: <1343109280-22653-1-git-send-email-lliubbo@gmail.com>
	<20120724192120.GB29239@thunk.org>
Date: Wed, 25 Jul 2012 21:09:02 +0800
Message-ID: <CAA_GA1eYnwF3ObT7Y7DGj2G83nzkyZ7efkM3_JWvASOQkPW9Yg@mail.gmail.com>
Subject: Re: [GIT PULL v2] Blackfin changes for 3.6-rc1
From: Bob Liu <lliubbo@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Bob Liu <lliubbo@gmail.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, vapier@gentoo.org,
        sonic.zhang@analog.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:21 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 24, 2012 at 01:54:40PM +0800, Bob Liu wrote:
>>
>> This is the new pull request about blackfin changes for 3.6-rc1.
>> I've rebased my tree to 3.5.
>
> To save Linus having to send you a chastising e-mail (and because I'll
> probably be more gentle about it than he would be :-), in general it's
> good not to rebase your the tree before submitting to Linus.  If you
> tested with your set of commits pon top of 3.5-rc3, then submit those
> patches that way.  Rebasing at least partially invalidates your
> testing, and causes other problems if someone else has based their
> tree off of yours.
>
> If the goal is to avoid merge conflicts, it's better to just resolve
> the conflict, and push the proposed merge resolution, and send Linus
> both the commit pre-merge, and post-merge, and let him decide if wants
> to use your merge resolution, or to fix things up in a slightly
> different way.
>

Got it, thanks a lot for your kindly explanation.

-- 
Regards,
--Bob
