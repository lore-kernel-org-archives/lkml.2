Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2JIMxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:53:22 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37641 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2JIMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:53:20 -0400
Date: Tue, 9 Oct 2012 14:53:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for s390 [ver #2]
Message-ID: <20121009145305.32435495@mschwide>
In-Reply-To: <21182.1349774152@warthog.procyon.org.uk>
References: <21182.1349774152@warthog.procyon.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12100912-5024-0000-0000-00000400F22B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Oct 2012 10:15:52 +0100
David Howells <dhowells@redhat.com> wrote:

> Can you merge the following branch into the s390 tree please.
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
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-s390-20121009
> 
> for you to fetch changes up to 9807f75955ea7f1877981056755284481873115c:
> 
>   UAPI: (Scripted) Disintegrate arch/s390/include/asm (2012-10-09 09:47:31 +0100)

Ok, rebased the s390 tree to get akpm's patch-bomb out of the way and merged the UAPI
patchset. Result can be gawked at here:

https://git.kernel.org/?p=linux/kernel/git/s390/linux.git;a=shortlog;h=refs/heads/features

I will send Linus a please pull soon.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

