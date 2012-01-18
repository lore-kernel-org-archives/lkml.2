Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2ARBLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:11:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50438 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab2ARBLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:11:16 -0500
Date: Tue, 17 Jan 2012 17:11:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118011112.GB32160@htj.dyndns.org>
References: <20120117201823.GD19223@redhat.com>
 <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 09:05:26AM +0800, Shaohua Li wrote:
> > Vivek is seeing the problem while switching elevators.  Are you too?
> > Or is it during normal operation?
> same here. I had some problems when I debug my ioscheduler, but
> eventually found even switching cfq and noop can trigger oops.

Hmmm... maybe quiescing isn't working as expected and kmem cache is
being destroyed with live icq's.  I'll try to reproduce it.

Thanks.

-- 
tejun
