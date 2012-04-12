Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965897Ab2DLTbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934514Ab2DLTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:31:49 -0400
Date: Thu, 12 Apr 2012 12:31:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: Re: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
Message-Id: <20120412123147.1ac34ae0.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1204121221420.2379@eggly.anvils>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
	<1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com>
	<CACVxJT_o-mR5u2XgDbECDM-SSR18j+wDY8pd7=Jb+FGCz4SSTQ@mail.gmail.com>
	<4F872322.8040909@gmail.com>
	<alpine.LSU.2.00.1204121221420.2379@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 12:26:51 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> On Thu, 12 Apr 2012, KOSAKI Motohiro wrote:
> > (4/12/12 9:23 AM), Alexey Dobriyan wrote:
> > > On Wed, Apr 11, 2012 at 8:59 AM, Cong Wang<xiyou.wangcong@gmail.com>
> > > wrote:
> > > > -       if (mm&&  !IS_ERR(mm)) {
> > > > +       if (!IS_ERR_OR_NULL(mm)) {
> > > 
> > > I personally find original code way more readable.
> > 
> > personally, me too. but new one is also acceptable to me.
> 
> That now makes 4 votes that it's not an improvement, with no dissent
> (unless akpm's + proc-use-is_err_or_null.patch added to -mm tree
> should be counted as dissent): let's drop this patch.

I think it's OK.  IS_ERR_OR_NULL encapsulates the concept "something
went wrong".

Not that I'm particularly passionate about it.
