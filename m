Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3AIC5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:57:30 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34064 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3AIC53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130108184920.GA1258@quad.lixom.net>
References: <20130108184920.GA1258@quad.lixom.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Jan 2013 18:57:08 -0800
X-Google-Sender-Auth: ajmnE2IpGgAe5tK4uPDoJWiUN10
Message-ID: <CA+55aFxxv2h8TAxvwprdQEpaz4Ww5ime+t8rmpjnjv2t-mWYaQ@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:49 AM, Olof Johansson <olof@lixom.net> wrote:
>
> A slightly larger delta than I'd ideally want by now, in part due to some
> of the OMAP PM fixes that's adding a bit of code. I decided to include
> it instead of push it to 3.9, but from here on out we'll be stricter.

Ugh. Not only that, but:

>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

you have both a branch called "fixes" and a tag called "fixes".
Ambiguous. And when you ask me to pull like the above, it actually
picks the branch, not the tag.

Don't do this. Either use the unambiguous name ("tags/fixes" rather
than just "fixes") or don't push out branches and tags that have the
same name.

                     Linus
