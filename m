Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1G1Elu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:41:50 -0400
Received: from mail.perches.com ([173.55.12.10]:4345 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab1G1Elo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:41:44 -0400
Subject: Re: broken checkpatch signature checking
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110728043327.GA21448@redhat.com>
References: <20110728043327.GA21448@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 21:41:42 -0700
Message-ID: <1311828102.10042.1.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 00:33 -0400, Dave Jones wrote:
> The signature checking patches in commit 2011247550 have broken one use-case for me.
> I pipe the git-commits mailing list to it and skim the summary once a day[*]
> Because git indents its changelogs, every single commit is now warning
> with this..
> WARNING: Do not use whitespace before Signed-off-by:
> #5252:
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 	Dave
> [*] It's too noisy to do anything useful with right now, which is
>     why I'd like to filter out all the whitespace crap, but hopefully
>     that'll happen eventually.

Hey Dave.

Maybe you could use --ignore=BAD_SIGN_OFF for this reviewing?

I think that the general use case is OK.

I'm not sure that it's appropriate to use
checkpatch on git log output.

cheers, Joe

