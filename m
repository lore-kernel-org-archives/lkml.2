Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2FMWUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:20:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMWUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:20:46 -0400
Date: Wed, 13 Jun 2012 15:20:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        sfr@canb.auug.org.au, jcm@jonmasters.org, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver.
 0.1.0)
Message-Id: <20120613152045.81ab66d9.akpm@linux-foundation.org>
In-Reply-To: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 20:57:02 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> I need to know what the right practice is to get your attention to
> accept a new tool upstream like this one.

Seems that you have some good feedback from Arnd to be looking at.  I'm
usually the guy for mysterious misc stuff such as this, so please cc me
on future revisions.

The name "hw_test" and "HW_TEST" is too vague.  The topic "testing
hardware" is very broad, and this module only touches a small fraction
of it, so please think up a far more specific name.

