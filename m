Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2LFGGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:06:22 -0500
Received: from ozlabs.org ([203.10.76.45]:54845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2LFGGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:06:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PULL] More module signing fixes.
In-Reply-To: <CA+55aFyhuC4hp-T7v8XOeaDf2N_DKThg-NpsShkJakyxLy42ww@mail.gmail.com>
References: <87624hgtlc.fsf@rustcorp.com.au> <CA+55aFyhuC4hp-T7v8XOeaDf2N_DKThg-NpsShkJakyxLy42ww@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 06 Dec 2012 16:27:02 +1030
Message-ID: <87r4n3g1u9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Dec 4, 2012 at 5:45 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git
>
> Nothing there. Forgot to push? Forgot to send me the proper tag/branch name?

How did I manage to get git request-pull to screw that up?

Weird.  This time seems to be the right branch: fixes.

Thanks,
Rusty.

The following changes since commit df2fc246c8ee8b6067af1fa55d3bc23107457f61:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2012-12-04 09:32:12 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git fixes

for you to fetch changes up to f3537f91f9be2ce5fcbaa1aa6d787ad0436daec6:

  ASN.1: Fix an indefinite length skip error (2012-12-05 11:27:39 +1030)

----------------------------------------------------------------
David Howells (2):
      MODSIGN: Don't use enum-type bitfields in module signature info block
      ASN.1: Fix an indefinite length skip error

 kernel/module_signing.c |   14 +++++++-------
 lib/asn1_decoder.c      |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)
