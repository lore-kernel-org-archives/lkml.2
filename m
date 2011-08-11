Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1HKVSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:18:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51089 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HKVSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:18:21 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Date: Thu, 11 Aug 2011 23:17:55 +0200
In-Reply-To: <CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	 <1313091323.8491.30.camel@twins>
	 <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
	 <1313094223.26866.15.camel@twins>
	 <CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313097475.26866.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 13:31 -0700, Alex Neronskiy wrote:
> 
> > I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
> > latency and the PREEMPT_RT kernels live at ~30us. So wth are you
> > measuring?
> Well, not all kernels have PREEMPT. Chromebook kernels don't, for example.

Can one infer from that statement that the purpose is trying to measure
non preempt latency? Why not use the tracer build for that purpose?

Still the watchdog ticks at 1s intervals or so, anything that takes that
long, even on voluntary preemption kernels is quite insane.


