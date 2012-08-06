Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2HFTKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:10:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58170 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFTKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:10:33 -0400
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20120806164914.GA25940@redhat.com>
References: <20120605051238.GA30614@redhat.com>
	<20120806164914.GA25940@redhat.com>
Date: Mon, 6 Aug 2012 15:10:32 -0400
Message-ID: <CAHC9VhSV4_-53WEAP66bLqw=mFi8jQnQ8D6YRQY_wmK9+Rg_Og@mail.gmail.com>
Subject: Re: Fix sel_netnode_insert suspicious rcu dereference.
From: Paul Moore <paul@paul-moore.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        eparis@redhat.com, paulmck@linux.vnet.ibm.com, paul@paul-moore.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 12:49 PM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Jun 05, 2012 at 01:12:39AM -0400, Dave Jones wrote:
>  > I reported this a year ago (https://lkml.org/lkml/2011/4/20/308).
>  > It's still a problem apparently ...
>
> And another two months pass in silence.
>
> This is happening to other people too.
> https://bugzilla.redhat.com/show_bug.cgi?id=846037
>
> Can someone please apply this patch, or at least point out what's wrong with it ?

I thought Eric had applied it a few months ago, but I just checked and
I don't see it in Linus' tree for some reason?  I know multiple
patches have been posted from different authors, all fixing the same
thing ...

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
