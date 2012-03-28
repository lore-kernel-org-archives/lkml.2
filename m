Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2C1U6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:58:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2C1U6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:58:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 4/5] ARM: More device tree support updates
Date: Wed, 28 Mar 2012 20:58:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1332918842-13521-1-git-send-email-olof@lixom.net> <1332918842-13521-5-git-send-email-olof@lixom.net> <CA+55aFy4QNiDTL2b37Y870kZ-09sFp9qsFn+SaKCbzWqm8xtoQ@mail.gmail.com>
In-Reply-To: <CA+55aFy4QNiDTL2b37Y870kZ-09sFp9qsFn+SaKCbzWqm8xtoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282058.20226.arnd@arndb.de>
X-Provags-ID: V02:K0:YdMOposT/TkmHo8CLWUFFC9TBu/GJyYJgRIUC5uoKOc
 bMuoRL1NM4iiIySMxgIHhW1ziymT1LfoV5B0BGoxdXEDu37eWP
 eAIiPKVDHOu0XQBXUzClknMw+SkEzGVFSGRojg4CIUJBRzPEX3
 3oO2tXmHiQCVG40vRAPpRpdx7rqkhtfP7MzpHeZLs2iS65ylTw
 jQWmofXGP37lE4V/OOp5I33KVcnmV4QWrLkVR0kShSbbMP2EZ7
 Q3pZVMpVZ75tl8K+4si82gcr/0zJB0zObjtsEBfh9L47CduzmV
 fYfnWAVYDMzsq1Wtq0npRGDVrAyVi2rIQgg3/01/k+C2blNck1
 cO5YbamFt5xSlva85BhE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012, Linus Torvalds wrote:
> On Wed, Mar 28, 2012 at 12:14 AM, Olof Johansson <olof@lixom.net> wrote:
> >
> > Merge conflicts and proposed solutions:
> >
> > arch/arm/mach-ux500/Kconfig: Two new config options. Keep both.
> 
> Guys, I'm seeing merge problems that go way beyond this.
> 
> Look at that MACH_U8500 config option. It got renamed to MACH_MOP500,
> but it continues to live in the tree.
> 
> This rename conflict happened earlier and I didn't notice (grep for
> it: it's used by a staging driver), so it's already in my pushed out
> tree. But it seems to be getting worse, and your proposed merge
> solution doesn't cover it.

Your solution looks good. I had the MACH_UX500_DT option above U5500
instead of below it in our for-next branch, but either way makes sense.

> I'll try to fix things up, but you need to verify my merge. And you
> guys should have noticed and noted it, rather than leave it to my
> random bumbling about.

Yes, noted for next time. We had a lot of merge conflicts because of
being relatively late in the merge window (this one was purely
self made though), and it's not always easy to decide which ones
to eliminate in advance, leave in or describe the resolution we found.

Since we usually see the same conflicts and resolve them in the
for-next branch, I guess it's easy enough to just always provide
the branch with the resolutions as a help for cases like this one.

	Arnd
