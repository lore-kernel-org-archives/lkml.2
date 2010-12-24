Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0LXNJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:09:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab0LXNJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:09:16 -0500
Date: Fri, 24 Dec 2010 05:04:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-23-16-58 uploaded
Message-Id: <20101224050459.0331deb7.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinegsqmSzXqqrF930abQfOBu6_MH1EToupKV214@mail.gmail.com>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
	<AANLkTinegsqmSzXqqrF930abQfOBu6_MH1EToupKV214@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 13:15:26 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> On Fri, Dec 24, 2010 at 1:58 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
> >
> > __ http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> > __ git://zen-kernel.org/kernel/mmotm.git
> >
> 
> The readme in [1] lists a wrong browseable GIT-repo URL:
> 
> "Alternatively, these patches are available in a git repository at
> 
> git:	git://zen-kernel.org/kernel/mmotm.git
> gitweb:	http://git.zen-kernel.org/?p=kernel/mmotm.git;a=summary"
> 
> Correct would be [2]:
> 
> gitweb: http://git.zen-kernel.org/mmotm/

hm, thanks.  The darn thing keeps moving around.

> > It contains the following patches against 2.6.37-rc7:
> >
> [...]
> > linux-next-git-rejects.patch
> 
> Hm, the content of this patch looks a bit strange.
> Is that a post-cleanup patch to linux-next merge?

Yes.  It's caused by skew between Linus's tree and linux-next.
