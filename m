Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2LMCx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:53:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43153 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2LMCx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:53:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121211090910.GA22985@gmail.com>
References: <20121211090910.GA22985@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 18:53:36 -0800
X-Google-Sender-Auth: 80CzE4b6vtZyYfJ3ibOTNxbKdMc
Message-ID: <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. This may be entirely unrelated to this particular pull request, but

   perf record -e cycles:pp

no longer works on my westmere machine (Operation not supported). It
used to work, but I haven't tried to bisect it, since I hope somebody
will just go "oh, I know what's up".

dmesg says:

  Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel
PMU driver.
  perf_event_intel: CPUID marked event: 'bus cycles' unavailable
  ... version:                3
  ... bit width:              48
  ... generic registers:      4
  ... value mask:             0000ffffffffffff
  ... max period:             000000007fffffff
  ... fixed-purpose events:   3
  ... event mask:             000000070000000f

Any ideas?

              Linus
