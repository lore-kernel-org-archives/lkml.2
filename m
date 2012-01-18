Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2ARBD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:03:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42889 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab2ARBD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:03:28 -0500
Date: Tue, 17 Jan 2012 17:03:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118010323.GA32160@htj.dyndns.org>
References: <20120117201823.GD19223@redhat.com>
 <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 09:01:00AM +0800, Shaohua Li wrote:
> 2012/1/18 Vivek Goyal <vgoyal@redhat.com>:
> >> Does the following patch make any difference?
> >
> > Nope. Still can reproduce the issue.
>
> I had similar issue too. Looks ioc_create_icq finds an icq (in ioc_lookup_icq)
> the icq is in rcu free (it has __rcu_icq_cache set)

Vivek is seeing the problem while switching elevators.  Are you too?
Or is it during normal operation?

Thanks.

--
tejun
