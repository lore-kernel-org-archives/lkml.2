Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0LADJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:09:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36677 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0LADJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:09:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/4] exec: unify compat/non-compat code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
In-Reply-To: <20101130200016.GD11905@redhat.com>
References: <20101130195456.GA11905@redhat.com> <20101130200016.GD11905@redhat.com>
Message-Id: <20101201120806.ABB9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 12:09:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (remove stable)
> 
> On 11/30, Oleg Nesterov wrote:
> >
> > I'll send the cleanups which unify compat/non-compat code on
> > top of these fixes, this is not stable material.
> 
> On top of
> 
> 	[PATCH 1/2] exec: make argv/envp memory visible to oom-killer
> 	[PATCH 2/2] exec: copy-and-paste the fixes into compat_do_execve() paths
> 
> Imho, execve code in fs/compat.c must die. It is very hard to
> maintain this copy-and-paste horror.

I strongly like this series. (yes, I made fault to forgot to change compat.c
multiple times ;)

Unfortunatelly, this is a bit large and I have no time now. I expect I
can review this at this or next weekend.....
Hopefully, anyoneelse will review this and ignore me....



