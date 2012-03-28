Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2C1ThD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:37:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59707 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2C1ThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:37:01 -0400
MIME-Version: 1.0
In-Reply-To: <1332918842-13521-5-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net> <1332918842-13521-5-git-send-email-olof@lixom.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Mar 2012 12:36:39 -0700
X-Google-Sender-Auth: vhizWWrDYTpA_RVy8jbMPfKAp3c
Message-ID: <CA+55aFy4QNiDTL2b37Y870kZ-09sFp9qsFn+SaKCbzWqm8xtoQ@mail.gmail.com>
Subject: Re: [GIT PULL 4/5] ARM: More device tree support updates
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:14 AM, Olof Johansson <olof@lixom.net> wrote:
>
> Merge conflicts and proposed solutions:
>
> arch/arm/mach-ux500/Kconfig: Two new config options. Keep both.

Guys, I'm seeing merge problems that go way beyond this.

Look at that MACH_U8500 config option. It got renamed to MACH_MOP500,
but it continues to live in the tree.

This rename conflict happened earlier and I didn't notice (grep for
it: it's used by a staging driver), so it's already in my pushed out
tree. But it seems to be getting worse, and your proposed merge
solution doesn't cover it.

I'll try to fix things up, but you need to verify my merge. And you
guys should have noticed and noted it, rather than leave it to my
random bumbling about.

                     Linus
