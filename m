Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1FDWvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 18:51:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab1FDWvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 18:51:04 -0400
MIME-Version: 1.0
In-Reply-To: <1307225323.2497.730.camel@laptop>
References: <20110405152729.232781355@chello.nl> <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de> <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
 <4DE8DC28.30709@die-jansens.de> <BANLkTikXU5FFgY4=8MEdRjvt4gbpxm7J5g@mail.gmail.com>
 <1307225323.2497.730.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Jun 2011 07:50:40 +0900
Message-ID: <BANLkTi=unLFAYsm7k_4PBxJb4W7iowZMyQ@mail.gmail.com>
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>, Ingo Molnar <mingo@elte.hu>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 7:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Yeah, that wants a whole lot of reverting, from the offending commit up
> to and including 317f394160e9beb97d19a84c39b7e5eb3d7815a8.

Mind sending one single tested patch? I still get conflicts, even just
trying to revert the last of those (ie 317f394160e9) due to all the
other scheduler changes..

                   Linus
