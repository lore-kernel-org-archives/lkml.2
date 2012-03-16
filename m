Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2CPFIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:08:35 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:49246 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab2CPFId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:08:33 -0400
Date: Fri, 16 Mar 2012 14:11:28 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout parameter when message can be performed immediately
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <alpine.LFD.2.02.1203151144280.2466@ionos>
References: <CA+55aFygRpuCZ0K0_hon7t3H+qa3WKb3--VXooN8p14S6or2tw@mail.gmail.com> <alpine.LFD.2.02.1203151144280.2466@ionos>
Message-Id: <20120316141128.DD0A.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 12:02:49 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 14 Mar 2012, Linus Torvalds wrote:
> > With the current code, checking the validity of the timeout falls out
> > from what we do. I don't think we need to work around that, based on
> > the POSIX wording. And if there are no applications that actually
> > broke, I don't think we should care.
> > 
> > Is there some other standard that says that you *have* to let crazy
> > invalid values go?
> 
> Not that I'm aware of. Everything I found so far is copied from the
> POSIX spec.

Okay. I agree with you on the interpretation of POSIX spec.
Andrew, could you remove my patch from -mm tree ?
I'll post a patch to LTP porject to modify the test program.

Thank you,

Akira Takeuchi

