Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0K3UCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:02:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0K3UC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:02:28 -0500
Date: Tue, 30 Nov 2010 20:54:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: [PATCH 0/2] exec: more excessive argument size fixes for
	2.6.37/stable
Message-ID: <20101130195456.GA11905@redhat.com>
References: <20101125140253.GA29371@redhat.com> <20101125193659.GA14510@redhat.com> <20101129093803.829F.A69D9226@jp.fujitsu.com> <20101129113357.GA30657@redhat.com> <20101129182332.GA21470@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129182332.GA21470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Oleg Nesterov wrote:
>
> I was going to export get_arg_page/acct_arg_size, but it is so
> ugly.

But I think this is the only option for 2.6.37/stable.

So. I am sending 2 patches, hopefully they fix the problems
and there are simple enough for 2.6.27/stable.

> I'll try to find the way to unify copy_strings and
> compat_copy_strings, not sure it is possible to do cleanly.

I'll send the cleanups which unify compat/non-compat code on
top of these fixes, this is not stable material.

Oleg.

