Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2K1XLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:11:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41781 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab2K1XLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:11:45 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121128205203.05868eab@pyramind.ukuu.org.uk>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-7-git-send-email-hpa@linux.intel.com> <20121128205203.05868eab@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6/8] x86, 386 removal: Remove CONFIG_X86_WP_WORKS_OK
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 28 Nov 2012 15:11:09 -0800
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Message-ID: <c1be9100-0fa6-40cf-91ea-82b206fd3e79@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the Nx586 was supported as a 386.  Again, doubt anyone cares at this point.

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>On Wed, 28 Nov 2012 11:50:28 -0800
>"H. Peter Anvin" <hpa@linux.intel.com> wrote:
>
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>> 
>> All 486+ CPUs support WP in supervisor mode, so remove the fallback
>> 386 support code.
>
>This breaks the Nx586 support. Do we care: I doubt it 8)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
