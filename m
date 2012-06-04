Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2FDKHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:07:05 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55243 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2FDKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:07:03 -0400
Date: Mon, 4 Jun 2012 05:07:00 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120604100700.GA4948@sgi.com>
References: <20120601155447.GG3671@sgi.com>
 <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 12:00:29AM -0700, Yinghai Lu wrote:
> On Fri, Jun 1, 2012 at 8:54 AM, Robin Holt <holt@sgi.com> wrote:
> > I just tried to boot an 8TB system.  It fails very early in boot with:
> >
> > Kernel panic - not syncing: Cannot find space for the kernel page tables
> >
> >
> > A git bisect lead me to commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
> >
> > A git revert of that commit based on Linus' current as of a few hours ago
> > (commit fb21aff) does boot past that point on the 8TB configuration.
> 
> have some local patches. please check if they are helping...

I will not have access to the machine until late tonight/early tomorrow
(approximately 24 hours from now).  I will try to give the patches a
run then.  Would you like them tested individually or as a set?

Robin
