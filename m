Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1G1NUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:20:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084Ab1G1NUU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Jul 2011 06:19:24 -0700
Message-ID: <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 10:16 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
>
> For all 160 commits, the branch "module.h-split", available here:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git
>
> has the complete content.  I've put the header changes after all the
> patches from the top 5 categories, so that people bisecting non related
> issues at a later date don't get hit with a commit zone with build failures.

Ok, sounds good. Two questions:

 - how much testing (randconfig? different architectures?) has this gotten?

 - how much does this actually improve compile times (for a "normal"
build or a "allmodconfig" one)?

It certainly sounds like the RightThing(tm) to do, but I'd like to
know that there is real actual improvements to build times and that
the pain won't be too bad...

             Linus
