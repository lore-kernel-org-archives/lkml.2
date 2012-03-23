Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2CWJCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:02:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:44237 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab2CWJB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:01:57 -0400
Date: Fri, 23 Mar 2012 10:01:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
In-Reply-To: <20120323090316.ED11.38390934@jp.panasonic.com>
Message-ID: <alpine.LFD.2.02.1203231001280.2542@ionos>
References: <alpine.LFD.2.02.1203151144280.2466@ionos> <20120316141128.DD0A.38390934@jp.panasonic.com> <20120323090316.ED11.38390934@jp.panasonic.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Akira Takeuchi wrote:

> > I'll post a patch to LTP porject to modify the test program.
> 
> FYI, I posted a patch to LTP project and it has been accepted.
> http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=commit;h=d6748f57df113699c7c948d734e2427234ef1d58
> 

Thanks for doing that.

       tglx
