Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520Ab2DLT1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:27:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53341 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab2DLT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:27:15 -0400
Date: Thu, 12 Apr 2012 12:26:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: Re: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
In-Reply-To: <4F872322.8040909@gmail.com>
Message-ID: <alpine.LSU.2.00.1204121221420.2379@eggly.anvils>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com> <1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com> <CACVxJT_o-mR5u2XgDbECDM-SSR18j+wDY8pd7=Jb+FGCz4SSTQ@mail.gmail.com> <4F872322.8040909@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, KOSAKI Motohiro wrote:
> (4/12/12 9:23 AM), Alexey Dobriyan wrote:
> > On Wed, Apr 11, 2012 at 8:59 AM, Cong Wang<xiyou.wangcong@gmail.com>
> > wrote:
> > > -       if (mm&&  !IS_ERR(mm)) {
> > > +       if (!IS_ERR_OR_NULL(mm)) {
> > 
> > I personally find original code way more readable.
> 
> personally, me too. but new one is also acceptable to me.

That now makes 4 votes that it's not an improvement, with no dissent
(unless akpm's + proc-use-is_err_or_null.patch added to -mm tree
should be counted as dissent): let's drop this patch.

Hugh
