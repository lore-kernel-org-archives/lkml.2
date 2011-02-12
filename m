Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1BLRwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:52:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab1BLRvy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:51:54 -0500
MIME-Version: 1.0
In-Reply-To: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn>
References: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 Feb 2011 09:51:32 -0800
Message-ID: <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com>
Subject: Re: [GIT PULL] UniCore32 ISA support for linux-2.6
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 5:32 PM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> Hi Linus,
>  Could you please pull from:
>    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git for_linus
>  to add unicore32 support for linux-2.6.

I'm not going to do it during the 38 cycle, but if this has has gotten
ack's from people like Arnd, and all the commentary from other people
(like the "the ptrace.c file looks like it was copied from arm, wants
attribution" etc), I can pull it in the 39 cycle.

Arnd - who else was involved in the reviews? Is there somebody who
_should_ have been involved and wasn't?

                        Linus
