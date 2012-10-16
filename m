Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2JPFP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:15:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53847 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2JPFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <21232.1349774169@warthog.procyon.org.uk>
References: <21232.1349774169@warthog.procyon.org.uk>
Date: Tue, 16 Oct 2012 09:15:55 +0400
Message-ID: <CAMo8BfKBX5tzYWT-xo9esj8CVhfBLOt7-UfJBbuqwQeo1vqG5g@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for xtensa [ver #2]
From: Max Filippov <jcmvbkbc@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 1:16 PM, David Howells <dhowells@redhat.com> wrote:
> Can you merge the following branch into the xtensa tree please.
>
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
>
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
>
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
>
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>
> are available in the git repository at:
>
>
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-xtensa-20121009
>
> for you to fetch changes up to 91a0696e40414e9f1554cd91060f6b404d545cb3:
>
>   UAPI: (Scripted) Disintegrate arch/xtensa/include/asm (2012-10-09 09:47:57 +0100)
>
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
>
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/xtensa/include/asm

Thanks, applied to the xtensa_next tree.

-- 
-- Max
