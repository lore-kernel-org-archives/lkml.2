Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1BWHWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:22:15 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51869 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab1BWHWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:22:13 -0500
X-Sasl-enc: drR7w6fKlRfXfm5DczoxL0WOKCfxgmdaRGl5ZFpH58aF 1298445732
Subject: Re: [PATCH 0/3] Fixes for vfs-scale and vfs-automount
From: Ian Kent <raven@themaw.net>
To: Nick Piggin <npiggin@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
In-Reply-To: <1297779902.13007.86.camel@perseus>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
	 <1295420817.3076.24.camel@perseus>  <1297779902.13007.86.camel@perseus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:22:05 +0800
Message-ID: <1298445725.20733.2.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 22:25 +0800, Ian Kent wrote:
> On Wed, 2011-01-19 at 15:06 +0800, Ian Kent wrote:
> > On Tue, 2011-01-18 at 12:05 +0800, Ian Kent wrote:
> > > I noticed a couple of problems which needed to be fixed before I can
> > > start testing.
> > 
> > Before I return to testing I thought I should let everyone know the
> > results so far, following the addition of the merged patches from this
> > thread.
> 
> Sorry for the large recipient list but I think there's a need.
> I've made very little progress on this but my most recent development
> deserves an update.
> 
> Most recent kernel used is 2.6.38-rc4.

Now at rc5, and still struggling with this but I have made some
progress.

Nick, what stops a dentry from going away during the rcu-walk?

Ian


