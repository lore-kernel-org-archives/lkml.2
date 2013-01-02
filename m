Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3ABSOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:14:47 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35622 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3ABSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:14:45 -0500
MIME-Version: 1.0
In-Reply-To: <50E3F49E.4090005@monstr.eu>
References: <50E3F49E.4090005@monstr.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Jan 2013 10:14:23 -0800
X-Google-Sender-Auth: ji-jh2LiEv2KnzrfmS1qpyKBzpQ
Message-ID: <CA+55aFyr2ZUzab3sV13VzcRmSp+St36Eo_tdUhnHDt3jz5p9HQ@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze changes for 3.8-rc2
To: Michal Simek <monstr@monstr.eu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 12:49 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Linus,
>
> please pull these 3 patches.
> They fix noMMU kernel and I have also added defconfig updates
> which fix issue with one external dependency and enable
> all xilinx device drivers for 0-day testing system.

No. I'm not pulling 3000 lines of broken defconfig crap.

That defconfig update is pure and utter shit, and changes from the
minimal kind of defconfig to the old-style "everything and the kitchen
sink" crap.

We started doing that defconfig minimization for a reason. See commit
8b1bb90701f9 for example. We're not going back to the bad old days,
and I'm not pulling thousands of lines or pure garbage noise just
because you were too lazy to do it right.

                     Linus
