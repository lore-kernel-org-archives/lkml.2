Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JQDhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:37:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy1c1Pn_czRoyybCGCsT89Rc7-kHfNCnH9xvc=p=1jrkQ@mail.gmail.com>
References: <20121015161401.17133.8590.stgit@warthog.procyon.org.uk>
	<CA+55aFy1c1Pn_czRoyybCGCsT89Rc7-kHfNCnH9xvc=p=1jrkQ@mail.gmail.com>
Date: Wed, 17 Oct 2012 09:07:03 +0530
X-Google-Sender-Auth: 5ySnPmwZKTKpZUpPs5FSTojdw5M
Message-ID: <CAOh2x=m=6fpzPVAS2wx9J-0rKpXVJar1sXnEsn7pA0g3KsmRgA@mail.gmail.com>
Subject: Re: [PATCH] Make uapi/linux/irqnr.h non-empty
From: viresh kumar <viresh.kumar@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alessandro Suardi <alessandro.suardi@gmail.com>,
        Michal Marek <mmarek@suse.cz>, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 7:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> Some of the empty files seem pointless. The
>
>   arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
>
> file, for example, has always been empty, and does not seem to be actually used.
>
> Hmm? I added a few more people to the cc list.

Shocked :)
I never realized these files were added by my commit and it never got caught in
reviews :(

Probably because git log --stat or git show (stat part) doesn't show
files with zero
changes. Probably need to fix that too?

@Arnd: Can you please apply following patch to fix SPEAr's issues
point out by Linus?

------------------------x-------------------x------------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 17 Oct 2012 08:58:08 +0530
Subject: [PATCH] ARM: SPEAr: Remove unused empty files

Few empty files (spear1310_misc_regs.h and spear1340_misc_regs.h) are created by
commit:

commit b31e23726bb9d6cd8848fc539b23330769830110
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Thu Apr 19 22:23:13 2012 +0530

    SPEAr13xx: Add header files

Don't know how they got added, obviously my fault :)
But nobody could even catch them in reviews.

Remove them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 0 files changed
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/spear1340_misc_regs.h

diff --git a/arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
b/arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
deleted file mode 100644
index e69de29..0000000
diff --git a/arch/arm/mach-spear13xx/include/mach/spear1340_misc_regs.h
b/arch/arm/mach-spear13xx/include/mach/spear1340_misc_regs.h
deleted file mode 100644
index e69de29..0000000
