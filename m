Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2H0RAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:00:17 -0400
Received: from ozlabs.org ([203.10.76.45]:53922 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab2H0RAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:00:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: linux-next: manual merge of the rr tree with the mips tree
In-Reply-To: <CAMuHMdV9VdJ__yWZwzUnM3=XiRo7NWxiJnnoOBgZ9Jg8v0RTNg@mail.gmail.com>
References: <20120822131130.d669275edf903d9a38a35789@canb.auug.org.au> <CAMuHMdV9VdJ__yWZwzUnM3=XiRo7NWxiJnnoOBgZ9Jg8v0RTNg@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 28 Aug 2012 02:16:22 +0930
Message-ID: <87ehmswae9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:
> Hi Stephen, David,
>
> On Wed, Aug 22, 2012 at 5:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Today's linux-next merge of the rr tree got a conflict in
>> arch/mips/kernel/module.c between commit c54de490a2e4 ("MIPS: Module:
>> Deal with malformed HI16/LO16 relocation sequences") from the mips tree
>> and commit 9db0bbe072c8 ("MIPS: Fix module.c build for 32 bit") from the
>> rr tree.
>>
>> Just context changes (I think).  I fixed it up (see below) and can carry
>> the fix as necessary.
>
>> + #endif
>
> At first I thought this merge conflict resolution introduced the bogus #endif:
>
> arch/mips/kernel/module.c:247:2: error: #endif without #if

That was my bad rebase against another patch.

Fixed now, thanks.

Rusty.
