Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550Ab1KCTcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:32:53 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35501 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509Ab1KCTcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:32:51 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <4EB14F51.1050004@nod.at>
References: <4EB14F51.1050004@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 20:32:30 +0100
Message-ID: <1320348750.14409.249.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 15:10 +0100, Richard Weinberger wrote:
> The following changes since commit
> c3b92c8787367a8bb53d57d9789b558f1295cc96:
> 
>   Linux 3.1 (2011-10-24 09:10:05 +0200)
> 
> are available in the git repository at:
>   git://github.com/richardweinberger/linux.git for-linus
[...]
>       um: take arch/um/sys-x86 to arch/x86/um

This is now mainline commit 5c48b108ecbf6505d929e64d50dace13ac2bdf34. It
broke "make update-po-config", as its symlink trick (again) fails.
Perhaps the people involved in commit
bdc69ca4cf972494ad06d1271760d94fdbb2e6b9 ("kconfig: change
update-po-config to reflect new layout of arch/um") care (they're CC'd).

(I only stumbled on that trick while searching for a way to check which
Kconfig file are actually used. I didn't actually need that trick. And I
didn't find any orphaned Kconfig files.) 


Paul Bolle

