Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab0E0RRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:17:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:33639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0E0RRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:17:22 -0400
Date: Thu, 27 May 2010 19:17:05 +0200
From: Jan Kara <jack@suse.cz>
To: Erik van der Kouwe <vdkouwe@cs.vu.nl>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Fam Zheng <famcool@gmail.com>
Subject: Re: [PATCH] fs/minix: bugfix, number of indirect block ptrs per
 block depends on block size
Message-ID: <20100527171705.GC3576@quack.suse.cz>
References: <4BFCF1EB.20709@cs.vu.nl>
 <20100526215442.GB3316@quack.suse.cz>
 <4BFEA7CD.6020703@cs.vu.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFEA7CD.6020703@cs.vu.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-05-10 19:11:41, Erik van der Kouwe wrote:
> Dear all,
> 
> >  Out of curiosity: Are you really using MINIX? The code is dead for a
> >long time...
> 
> MINIX is very much alive, see http://www.minix3.org/.
> 
> I work in the team developing MINIX. Being able to exchange data
> between Linux and MINIX is very useful for us and there is no other
> filesystem that the two share. We have been aware of (and annoyed
> by) this problem for a long time, but didn't know the cause (and
> didn't have much time to check). Feiran is a GSoC student working on
> our project and he found the issue when setting up his development
> environment so then we decided to bring out a patch.
  OK, I was more speaking about the Linux MINIX filesystem driver but it's
good to know someone is still using it :) Thanks for education.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
