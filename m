Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2CWAD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:03:58 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:60269 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab2CWAD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:03:56 -0400
Date: Fri, 23 Mar 2012 09:03:16 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout parameter when message can be performed immediately
Cc: linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20120316141128.DD0A.38390934@jp.panasonic.com>
References: <alpine.LFD.2.02.1203151144280.2466@ionos> <20120316141128.DD0A.38390934@jp.panasonic.com>
Message-Id: <20120323090316.ED11.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll post a patch to LTP porject to modify the test program.

FYI, I posted a patch to LTP project and it has been accepted.
http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=commit;h=d6748f57df113699c7c948d734e2427234ef1d58


Regards,
Akira Takeuchi

