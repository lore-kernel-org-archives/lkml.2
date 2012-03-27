Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2C0W0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:26:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61897 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2C0W0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:26:16 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1332626568-17812-9-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
	<1332626568-17812-9-git-send-email-arnd@arndb.de>
Date: Tue, 27 Mar 2012 15:26:15 -0700
Message-ID: <CAOesGMhhS4Hat1mzvz+rxdwwPXnNx9e6G7pQR1JNYXmhL_BLUQ@mail.gmail.com>
Subject: Re: [GIT PULL 06/09] ARM: board specific updates
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Sat, Mar 24, 2012 at 3:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> These changes are all specific to one board only. We're trying to keep
> the number of board files low, but generally board level updates are
> ok on platforms that are working on moving towards DT based probing,
> which will eventually lead to removing them.
>
> The board-ams-delta.c board file gets a conflict between the removal of
> ams_delta_config and the addition of a lot of other data. The Kconfig
> file has two changes in the same line, and in exynos, the power domain
> cleanup conflicts with the addition of the image sensor device.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> The following changes since commit "abd43e4 Merge branch 'next/boards'
> into for-next", leading up to commit " b9e1122 Merge tag 'asoc-3.4'
> of git://git.kernel.org/pub/scm", are available in
>
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards

The topmost commit on the branch had a mismerge causing compilation
failures on OMAP4 (arch/arm/mach-omap2/board-oamp4panda.c).

I've amended in the fix with the top merge commit to fix it, updated
the tag and pushed out the new branch and tag to the repo. The
diffstat should be identical, but the signature is obviously from me,
not Arnd.


-Olof
