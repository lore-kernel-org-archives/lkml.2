Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab0JHVug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:50:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0JHVuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:50:35 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: Linux 2.6.36-rc7
Date: Fri, 8 Oct 2010 23:50:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <201010081406.10190.agruen@suse.de> <4CAF47F3.3070800@caviumnetworks.com>
In-Reply-To: <4CAF47F3.3070800@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010082350.01135.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 October 2010 18:33:55 David Daney wrote:
> On 10/08/2010 05:06 AM, Andreas Gruenbacher wrote:
> > On Thursday 07 October 2010 19:49:28 Eric Paris wrote:
> >> The safest thing would probably be to punt the syscalls to 2.6.37.
> >> Which is sad since I know a number of people are already working against
> >> them, but maybe that proves it's the best approach?
> >
> > I agree with removing the syscalls from 2.6.36 because of the following
> > reasons:
> 
> How would the mechanics of this be achieved?
> 
> Is it enough to just unconditionally return -ENOSYS from the sys_*() 
> functions?  Or should all the patches be reverted?

Whatever works I guess ... they would get reactivated pretty soon, anyway.

Andreas
