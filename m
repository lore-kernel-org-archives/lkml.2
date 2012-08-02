Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2HBXxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 19:53:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48658 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2HBXxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 19:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <500DB2E2.6070703@linaro.org>
References: <20120722133441.GA6874@gmail.com> <20120723144917.GF793@phenom.dumpdata.com>
 <500D8CDD.3060309@linaro.org> <20120723182431.GD21870@phenom.dumpdata.com>
 <500D9EBC.204@linaro.org> <20120723195144.GA3454@phenom.dumpdata.com> <500DB2E2.6070703@linaro.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Aug 2012 16:52:40 -0700
X-Google-Sender-Auth: _A0ebqoUPuWpV5wYbIRnLnYpVZo
Message-ID: <CA+55aFwK8y2p=m7fEQxiHj0L8BKEpiHDX=cKX80XgAT9DLs6Sg@mail.gmail.com>
Subject: Re: [Xen-devel] Was: Re: [GIT PULL] timer changes for v3.6, Is:
 Regression introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
To: John Stultz <john.stultz@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 1:24 PM, John Stultz <john.stultz@linaro.org> wrote:
>
> Great! Thanks again so much for the testing and quick reporting!

Hmm. I'm just cutting 3.6-rc1, and noticing that apparently this patch
never reached me. So now -rc1 is broken on 32 bit under Xen.

I'm not going to delay rc1 for this, but I thought I'd point this out
in the hope that we get it fixed soon. I'll be around for small fixes
for another day and a half before I'm traveling for vacation.

              Linus
