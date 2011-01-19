Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1ASMbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:31:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62492 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1ASMbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:31:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mR0ONqRoa2rJjsUFtwawGKFXHQw9yr/aiFsSGaDo8hyuhbEOh0Y68OILhV4rhGyBOp
         OzZ1L+uJsn260qyD8efNBgAwtNnH2VyUMstpeCZpNVt36EqRJNQql6+lRqtY2kn2w+SB
         pGwjoLuewPDX4O+imZz/aCBjNlK6TnrC0F5XU=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCw74WyhmLAjnBn_vd=iPWe-QEZCP-N+ghSRoC@mail.gmail.com>
References: <AANLkTikCw74WyhmLAjnBn_vd=iPWe-QEZCP-N+ghSRoC@mail.gmail.com>
Date: Wed, 19 Jan 2011 04:31:06 -0800
Message-ID: <AANLkTimdtFtextcHTwUA93AL7EQegeC26M7mWLsQKdZU@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
From: "H.J. Lu" <hjl.tools@gmail.com>
To: sedat.dilek@gmail.com
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Matthias Klose <doko@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:32 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Referring to the original posting from [1]:
>
> I am on latest linux-next (next-20110118) which has also [3] included,
> x86_32 and using binutils-2.21 with PR ld/12327 fix from
> Debian/experimental (see [2]).
>
> AFAICS the changes to my kernel-config... You are on x86_64 and have not set:
>
> CONFIG_RELOCATABLE=y
> CONFIG_X86_NEED_RELOCS=y
>
> Ifdef *also* for CONFIG_RELOCATABLE for the parts in commit from [3] ?
>
> - Sedat -
>
> [1] http://lkml.org/lkml/2011/1/19/52
> [2] http://bazaar.launchpad.net/~doko/binutils/pkg-2.21-debian/revision/85
> [3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=86b1e8dd83cbb0
>

Looks like the patch has been reverted.


-- 
H.J.
