Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1CAMtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:49:45 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48392 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802Ab1CAMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:49:43 -0500
X-Sasl-enc: SlPGp1l6bw5MimXYTepSddHxa0ean8cE8ZdaR94f9s64 1298983782
Subject: Re: [PATCH 0/4] more on vfs-scale and vfs-automount
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 20:49:37 +0800
Message-ID: <1298983777.3726.37.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 12:56 +0800, Ian Kent wrote:
> 
> I am still seeing occassional incorrect ENOENT returns. They must be
> comming from the VFS or the daemon as I've changed almost all the
> ENOENT returns in the autofs module to identify where it's comming
> from.

That's not quite right either.
I got another of these (after 5 runs of my test) but from the autofs
module this time which means I still have a race on blocking pending
mounts. Oh well, there's still more for me to do.

Ian

