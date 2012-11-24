Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab2KXJMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:12:32 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab2KXJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:12:30 -0500
Date: Sat, 24 Nov 2012 10:12:20 +0100
From: Richard Weinberger <richard@nod.at>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] hostfs: fix a not needed double check
Message-ID: <20121124101220.75802fd1@spider.haslach.nod.at>
In-Reply-To: <50B08D28.40809@gmail.com>
References: <508276D3.5000708@gmail.com>
	<50A8A382.7020400@gmail.com>
	<50B08D28.40809@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat, 24 Nov 2012 10:02:32 +0100
schrieb Marco Stornelli <marco.stornelli@gmail.com>:

> Il 18/11/2012 09:59, Marco Stornelli ha scritto:
> > Il 20/10/2012 12:02, Marco Stornelli ha scritto:
> >> With the commit 3be2be0a32c18b0fd6d623cda63174a332ca0de1 we removed
> >> vmtruncate,
> >> but actaully there is no need to call inode_newsize_ok() because
> >> the checks are
> >> already done in inode_change_ok() at the begin of the function.
> >>
> >> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> 
> I didn't receive any feedback from Weinberger, could you consider
> this patch for next -rc?

Whoops. Sorry. -ENOMAL.

I can carry this patch through uml.git

Thanks,
//richard
