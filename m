Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091Ab2COLC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:02:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:39584 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2COLC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:02:56 -0400
Date: Thu, 15 Mar 2012 12:02:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
In-Reply-To: <CA+55aFygRpuCZ0K0_hon7t3H+qa3WKb3--VXooN8p14S6or2tw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203151144280.2466@ionos>
References: <20120302164234.4938.38390934@jp.panasonic.com> <20120314144601.ccc50a68.akpm@linux-foundation.org> <alpine.LFD.2.02.1203142250500.2466@ionos> <alpine.LFD.2.02.1203150056361.2466@ionos>
 <CA+55aFygRpuCZ0K0_hon7t3H+qa3WKb3--VXooN8p14S6or2tw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Linus Torvalds wrote:
> With the current code, checking the validity of the timeout falls out
> from what we do. I don't think we need to work around that, based on
> the POSIX wording. And if there are no applications that actually
> broke, I don't think we should care.
> 
> Is there some other standard that says that you *have* to let crazy
> invalid values go?

Not that I'm aware of. Everything I found so far is copied from the
POSIX spec.

Thanks,

	tglx
