Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab1FAVJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:09:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758802Ab1FAVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <4DE6936F.7090700@die-jansens.de>
References: <20110405152729.232781355@chello.nl> <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Jun 2011 06:09:09 +0900
Message-ID: <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot-time hang - maybe due to the mis-merge that re-introduced the
infinite media change signals for ide-cd?

I just pushed out a fix, it may not have mirrored out yet.

I dunno. Worth checking out before spending a lot of time bisecting.

                 Linus
