Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0EQLr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0EQLr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:47:27 -0400
Date: Mon, 17 May 2010 13:46:55 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] smbfs: BKL ioctl pushdown
In-Reply-To: <20100517023508.GG22299@nowhere>
Message-ID: <alpine.LFD.2.00.1005171345000.21420@localhost.localdomain>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-6-git-send-email-jkacur@redhat.com> <20100517023508.GG22299@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Frederic Weisbecker wrote:

> On Wed, May 05, 2010 at 03:15:38PM +0200, John Kacur wrote:
> > Convert smb_ioctl to an unlocked ioctl and push down the bkl into it.
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> 
> In fact this one doesn't apply, not a single hunk.
> 
> Against which tree have you made this patch?

It was just Linus's latest, after 2.6.34-rc6
at commit 7ebd467551ed6ae200d7835a84bbda0dcadaa511
