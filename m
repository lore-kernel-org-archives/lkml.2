Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab2IDWlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:41:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:41:44 -0400
Date: Tue, 4 Sep 2012 15:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yan yan <clouds.yan@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
Message-Id: <20120904154143.f6bcbdb4.akpm@linux-foundation.org>
In-Reply-To: <CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
	<1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
	<50456F2E.6060408@gmail.com>
	<CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 17:22:15 +0800
yan yan <clouds.yan@gmail.com> wrote:

> 2012/9/4 Cong Wang <xiyou.wangcong@gmail.com>:
> > On 09/03/2012 10:14 PM, yan wrote:
> >>
> >> Signed-off-by: yan <clouds.yan@gmail.com>
> >
> >
> > Please provide a changelog to explain why we need this patch.
> 
> I think the title is self explained.

Given this review feedback, the title alone was obviously insufficient!

I provided the following changelog text:

: If proc_get_inode() returns NULL then presumably it encountered memory
: exhaustion.  proc_lookup_de() should return -ENOMEM in this case, not
: -EINVAL.


