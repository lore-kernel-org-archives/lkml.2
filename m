Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1BECnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 21:43:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab1BECnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 21:43:07 -0500
Date: Fri, 4 Feb 2011 18:43:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-02-04-15-15 uploaded
Message-Id: <20110204184300.ebcddedb.akpm@linux-foundation.org>
In-Reply-To: <20110205133450.0204834f.sfr@canb.auug.org.au>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
	<20110205133450.0204834f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011 13:34:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 04 Feb 2011 15:15:17 -0800 akpm@linux-foundation.org wrote:
> >
> > The mm-of-the-moment snapshot 2011-02-04-15-15 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> 
> Just an FYI (origin is the above git repo):
> 
> $ git remote update origin
> Fetching origin
> fatal: read error: Connection reset by peer
> error: Could not fetch origin

Yes, that's been dead for a while and James isn't responding to email.

> Also, I create a similar git tree myself and two of the patches would not
> import using "git am" due to missing "From:" lines:
> 
> drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition.patch
> memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch

Thanks, I fixed those up.
