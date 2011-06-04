Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1FDVa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 17:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab1FDVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 17:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <4DE8DC28.30709@die-jansens.de>
References: <20110405152729.232781355@chello.nl> <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de> <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
 <4DE8DC28.30709@die-jansens.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Jun 2011 06:29:33 +0900
Message-ID: <BANLkTikXU5FFgY4=8MEdRjvt4gbpxm7J5g@mail.gmail.com>
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
To: Arne Jansen <lists@die-jansens.de>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 10:05 PM, Arne Jansen <lists@die-jansens.de> wrote:
>
> No change. Also git bisect quite clearly points to
> 0122ec5b02f766c and ab2515c4b98f7bc4, both are older than
> b1c43f82c5aa2654 mentioned in the other thread.

Ok, I haven't heard anything further on this. Ingo? Peter?

We're getting to the point where we just need to revert the thing,
since I'm not getting the feeling that there are any fixes
forthcoming, and I'd like -rc2 to not have this kind of bisected bug.

Ingo? Those two commits no longer revert cleanly, presumably due to
other changes in the area (but I didn't check). Can you do a patch to
do the reverts, and then you can try to re-do the thing later once you
figure out what's wrong.

                       Linus
