Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab0IHO4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:56:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab0IHO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:56:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6>
References: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Sep 2010 07:54:57 -0700
Message-ID: <AANLkTikYEjV8ikkPsfJ0d7WsikWHJ0n74u9uDS4uGHC+@mail.gmail.com>
Subject: Re: [GIT pull] Preparatory patch for semaphore cleanup
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 6:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This patch just provides the DEFINE_SEMAPHORE macro which is required
> for the various subsystem cleanups I sent out, so we can finally get
> rid of init_MUTEX[_LOCKED] in 2.6.37.

Why is it called DEFINE_SEMAPHORE(), when two lines later the we have
DECLARE_MUTEX()?

IOW, the whole DEFINE vs DECLARE thing seems confused. I'm not saying
one is better than the other (maybe "define" is), but the mixing of
names is worse than either, I feel..

                     Linus
