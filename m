Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1ASIca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:32:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46652 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1ASIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=R3EaFndGh6erjAEBKP2ZxzlJXYrpwvC3mx2qz2DjDchjgn3aXNhtR2DQsBfy5aV50b
         wIowRqQQEHO86/aC4hWvWmLDCQ26uZ6s0Dk8HP/9PRv6DLzdhWwIOPkpXEoV+U+ODgXv
         eyjeLBd3sIr4U+iztN1y7x54EHPr20Z4Z/5S8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 19 Jan 2011 09:32:28 +0100
Message-ID: <AANLkTikCw74WyhmLAjnBn_vd=iPWe-QEZCP-N+ghSRoC@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        Matthias Klose <doko@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Referring to the original posting from [1]:

I am on latest linux-next (next-20110118) which has also [3] included,
x86_32 and using binutils-2.21 with PR ld/12327 fix from
Debian/experimental (see [2]).

AFAICS the changes to my kernel-config... You are on x86_64 and have not set:

CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y

Ifdef *also* for CONFIG_RELOCATABLE for the parts in commit from [3] ?

- Sedat -

[1] http://lkml.org/lkml/2011/1/19/52
[2] http://bazaar.launchpad.net/~doko/binutils/pkg-2.21-debian/revision/85
[3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=86b1e8dd83cbb0
