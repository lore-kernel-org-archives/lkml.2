Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2LAVQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 16:16:46 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33746 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2LAVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 16:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121201111609.GA18679@gmail.com>
References: <20121201111609.GA18679@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Dec 2012 13:16:22 -0800
X-Google-Sender-Auth: XR34o9E71Xp28Q5jJBBoWyfwIOE
Message-ID: <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
To: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 3:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please [RFC] pull the latest sched-urgent-for-linus git tree
> from:

No. That patch is braindead. I wouldn't pull it even if it wasn't this late.

Why the hell leave a read-only 'sched_autogroup_enabled' proc file?
What the f*ck is the point? It looks like the flag still exists (we
test it), but now there's no point to it, since you can't change it.

What am I missing?

                Linus
