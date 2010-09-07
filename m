Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0IGP2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:28:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab0IGP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:28:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/30] semaphore cleanup
Date: Tue, 7 Sep 2010 17:27:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20100907124636.880953480@linutronix.de>
In-Reply-To: <20100907124636.880953480@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071727.55023.arnd@arndb.de>
X-Provags-ID: V02:K0:uQ9E+Vi/GyUjeJ1HJ1p2MFtC8onk8A6BWAyL7NvOXaC
 9YYFFr/n+5kNT0plrNNQysLN4mhZvmSSpvNURU3Z+aR7mD6vRe
 RmRuBscANP8pOsUL/x/DkxSgR3kDfu2Qku8M5oIw+J8NlFnZcU
 I2oYj9Fz+AFWT/0EZ4UhXDUyArMPER5t4E8ND0cWo6OIJgbUZD
 1JRQQY07u18UBiyblWZrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010, Thomas Gleixner wrote:
> init_MUTEX[_LOCKED] and DECLARE_MUTEX are deprecated for quite some
> time. Cleanup the remaining users and remove the cruft.

How many of these really need to be semaphores and can't be converted
to mutex or completion? I thought that we wanted to send the classic
semaphore the same way as the BKL eventually.

	Arnd
