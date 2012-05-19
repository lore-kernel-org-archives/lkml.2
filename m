Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2ESKci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:32:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2ESKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <4FB66756.2060302@redhat.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	<4FB66756.2060302@redhat.com>
Date: Sat, 19 May 2012 13:32:35 +0300
X-Google-Sender-Auth: JH2ekt3pUYD76hJk-OFugG57K4o
Message-ID: <CAOJsxLFnM4iYgBAfr+t4EHgqSce_x1rtGOwQ_twAQ18YnDVx8g@mail.gmail.com>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 6:14 PM, Rik van Riel <riel@redhat.com> wrote:
> I am not convinced this is the right way forward.
>
> While this may work well for programs written in languages
> with pointers, and for virtual machines, I do not see how
> eg. a JVM could provide useful hints to the kernel, because
> the Java program running on top has no idea about the
> memory addresses of its objects, and the Java language has
> no way to hint which thread will be the predominant user
> of an object.

True.

OTOH, while autonuma seems to be better for the JVM, numa sched is a
significant improvement over current code:

http://lkml.indiana.edu/hypermail/linux/kernel/1204.0/01200.html

Why is that?
