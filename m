Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2KNFhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:37:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2KNFhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:37:47 -0500
Date: Tue, 13 Nov 2012 21:37:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121113213742.292f3ace.akpm@linux-foundation.org>
In-Reply-To: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 16:30:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> News: next-20121115 (i.e. tomorrow) will be the last release until
> next-20121126 (which should be just be after -rc7, I guess - assuming
> that Linus does not release v3.7 before then), so if you want something
> in linux-next for a reasonable amount of testing, it should probably be
> committed tomorrow.

It would help if the old sched/numa code wasn't in -next while you're
away.  That would give me a clean run at 3.7 and will make it easier
for others to integrate and test the four(!) different
autoschednumacore implementations on top of linux-next.

Pretty please?

Also, I need to get a fresh mmotm into -next tomorrow.  Don't do
anything until I've pulled that rabbit out of the hat :)
