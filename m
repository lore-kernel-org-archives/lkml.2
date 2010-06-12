Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0FLRKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 13:10:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab0FLRKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 13:10:14 -0400
Date: Sat, 12 Jun 2010 10:10:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100612101014.8dfd2843.akpm@linux-foundation.org>
In-Reply-To: <20100613013718.e724d5e0.sfr@canb.auug.org.au>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
	<20100613013718.e724d5e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jun 2010 01:37:18 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Fri, 11 Jun 2010 16:40:13 -0700 akpm@linux-foundation.org wrote:
> >
> > The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> 
> The version in this git tree stops just before patch
> scsi-remove-private-bit-macros.patch.  I suspect that is because "git am"
> doe not like that patch (it has "a/./drivers..." as the file names).

git bug.  I fixed the patch.

> There are a few later patches that "git am" also does not like - because
> either they have no commit message

That should be OK - we often have unchangelogged patches.  Real simple ones.

>, no From: line,

Well.  What From: line do I put on origin.patch and linux-next.patch??

I fixed the others.

> or do not apply
> without some fuzz.

That's a bit silly.  Oh well, I can try to remember to rediff
everything before uploading.

