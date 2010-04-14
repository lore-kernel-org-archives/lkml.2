Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0DNR42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:56:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41546 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0DNR4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p+2AiUEJ2AaXe1ZtIQWOAzJ5xgV6uEAQc58gYLP90iPDPyxERXcWUnElJjDq+XCJBU
         izwdNy9tBKzXk1Y1GH9s1HGH7S58KS+K0vRuRI8z2SgMgZ48qUlhMUAYmi7BH+96NPKp
         AK/LVKXxvLXoG9kjcJpJ9UVtCS2bfQVRgZwcM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003292048530.3832@ayla.of.borg>
References: <alpine.DEB.2.00.1003292048530.3832@ayla.of.borg>
Date: Wed, 14 Apr 2010 19:56:24 +0200
X-Google-Sender-Auth: 885b9f5ed05a1af3
Message-ID: <k2m10f740e81004141056xa6b6328dxb52c4cbc7d6f0a07@mail.gmail.com>
Subject: Re: [git pull] m68k updates for 2.6.34
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 20:52, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Please pull to receive 2 more m68k updates for 2.6.34:
>  - The first one fixes a build problem we started seeing lately,
>  - The second one corrects struct sigcontext for ColdFire, as I've
>    accidentally merged the wrong version of a patch for the previous
>    pull request.
>
> Thanks!

This one is still valid, I've just rebased to the latest version.
Thaks for pulling!

The following changes since commit 2ba3abd8186f24c7fb418927025b4e2120e3a362:
  Linus Torvalds (1):
        Merge branch 'pm-fixes' of git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Fix asm constraints for atomic_sub_and_test() and
atomic_add_negative()

Maxim Kuvyrkov (1):
      m68k: Fix `struct sigcontext' for ColdFire

 arch/m68k/include/asm/atomic_mm.h  |    8 ++++++--
 arch/m68k/include/asm/sigcontext.h |    4 +---
 2 files changed, 7 insertions(+), 5 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
