Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab1E0APS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:15:18 -0400
Received: from tundra.namei.org ([65.99.196.166]:59008 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab1E0APR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:15:17 -0400
Date: Fri, 27 May 2011 10:12:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
In-Reply-To: <20110526183806.GB2490@elte.hu>
Message-ID: <alpine.LRH.2.00.1105271010290.9616@tundra.namei.org>
References: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu> <4DDE31D6.4070209@redhat.com>
 <20110526113842.GA27618@elte.hu> <4DDE96B7.8030006@redhat.com> <20110526181554.GB3572@elte.hu> <1306434167.2497.92.camel@laptop> <20110526183806.GB2490@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, if anyone's going to be at Plumbers this year, we have a day set 
aside for the security summit:

https://security.wiki.kernel.org/index.php/LinuxSecuritySummit2011

This may make a good discussion topic.


- James
-- 
James Morris
<jmorris@namei.org>
