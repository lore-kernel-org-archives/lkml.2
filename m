Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2LYL6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:58:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44440 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab2LYL6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:58:47 -0500
Date: Tue, 25 Dec 2012 12:58:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: bbi5291 <bbi5291@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does init start with any open files?
Message-ID: <20121225115844.GG7692@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	bbi5291 <bbi5291@gmail.com>, linux-kernel@vger.kernel.org
References: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
 <20121225111742.GB7720@liondog.tnic>
 <CAMmfjbNmN0pPXr-HY7qzK52YpwoSU76q1Puog951X7h099XHBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMmfjbNmN0pPXr-HY7qzK52YpwoSU76q1Puog951X7h099XHBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all,

please do not top-post. You can search the net for why top-posting is
discouraged.

On Tue, Dec 25, 2012 at 06:25:11AM -0500, bbi5291 wrote:
> Well, that can't be right---I grepped the kernel source for "initctl"
> and got no results.

That's because it is a named pipe.

> Besides, if you're running a shell, then init has already had time
> to open and close whatever file descriptors it wants to. What I want
> to know is whether init has any open file descriptors, at, say, the
> moment its main() starts executing.

You probably want to stare at init/main.c:kernel_init() and what it
calls, and then download the sources of the init executable which is run
on your distro, whip up a text editor and start staring at them.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
