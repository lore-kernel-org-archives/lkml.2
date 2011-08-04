Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1HDCD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 22:03:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546Ab1HDCDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 22:03:53 -0400
Date: Wed, 3 Aug 2011 19:06:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Ayan George <ayan@ayan.net>, linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
Message-Id: <20110803190622.818b5852.akpm@linux-foundation.org>
In-Reply-To: <4E39FCC0.4000800@cfl.rr.com>
References: <4E1F3BE0.8040506@ayan.net>
	<4E209132.7000704@cfl.rr.com>
	<20110715121903.dc543613.akpm@linux-foundation.org>
	<4E39FCC0.4000800@cfl.rr.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Aug 2011 21:58:24 -0400 Phillip Susi <psusi@cfl.rr.com> wrote:

> On 07/15/2011 03:19 PM, Andrew Morton wrote:
> > The patch appears to do two unrelated things.  That's generally frowned
> > upon, but doesn't bother me much if the patch is small.
> > 
> > Still, splitting it into two patches (in which the bugfix is staged
> > first) would be advantageous for people who might wish to backport the
> > fix into earlier kernels.
> 
> It looks like this got stalled and someone emailed me asking what
> happened to it.  I'm not sure that splitting the patch in two makes
> sense.  I don't see how it does two unrelated things.  The uevent
> problem was caused by the argument being NULL.  This patch just removes
> the argument since it is entirely unnecessary.  Given that the argument
> is gone and can no longer be passed as NULL, the tests for NULL are
> rendered moot, and so removing them seems quite related.  I suppose you
> could do the first and not the second, but then you would be leaving
> cruft behind.

Am still waiting for someone to say that this is tested.

And what is "my previous patch"?  "emit uevent on auto release"?
