Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2AJQJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:09:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60145 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2AJQJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120110083933.GS21765@n2100.arm.linux.org.uk>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
 <1326147171-13752-6-git-send-email-arnd@arndb.de> <CA+55aFyaOnJhrZOFnRiShH9kTeGEG8O8m9spvKF=c36QzjSvBA@mail.gmail.com>
 <20120110083933.GS21765@n2100.arm.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 08:08:56 -0800
X-Google-Sender-Auth: 2btEslqH97AlnV59KZV_Ni-BOAk
Message-ID: <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 12:39 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> What about using -C instead (which implies -M, but also detects copies) ?

I don't mind -C. It sometimes causes differences to what I see by
default, but those differences are often interesting.

But while it's interesting and relevant (unlike the non-rename patch
that is just noisy), it also can hide lots of lines. With -C, you can
get a diffstat that is actually fairly small, but that adds a lot of
lines to the kernel (because somebody just copied large files with
small changes), and if that happens I do want to see it as a "big
change". So for me, the plain "just show renames" is a good default.

So there is absolutely nothing wrong with -C. It's not what I use, but
when I see that the diffstats don't match, it's easy to notice why,
and that information is often fairly interesting, so I don't mind.

                    Linus
