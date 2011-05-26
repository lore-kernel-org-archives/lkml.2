Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab1EZSUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:20:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:47359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab1EZSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:20:23 -0400
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system
 call filtering
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20110526181554.GB3572@elte.hu>
References: <alpine.LFD.2.02.1105251836030.3078@ionos>
	 <20110525180100.GY19633@outflux.net>
	 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
	 <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com>
	 <20110526093040.GB19536@elte.hu> <4DDE31D6.4070209@redhat.com>
	 <20110526113842.GA27618@elte.hu> <4DDE96B7.8030006@redhat.com>
	 <20110526181554.GB3572@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 20:22:47 +0200
Message-ID: <1306434167.2497.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 20:15 +0200, Ingo Molnar wrote:
> Incidentally i suggested this to Pekka just yesterday: i think we 
> should consider guest RAM images to be named files on the local 
> filesystem (prefixed with the disk image's name or so, for easy 
> identification), 

That'll break THP and KSM, both rely and work on anon only.

