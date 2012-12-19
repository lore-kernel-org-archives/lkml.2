Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2LSVel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:34:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2LSVef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:34:35 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFxeOK5mvuLubtdRLGrnX3waY=wBisFFE49b-nSwGiLaKg@mail.gmail.com>
References: <201212192022.qBJKMrJ6021946@tazenda.hos.anvin.org> <CA+55aFxeOK5mvuLubtdRLGrnX3waY=wBisFFE49b-nSwGiLaKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Additional x86 fixes for v3.8-rc1
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 19 Dec 2012 13:33:40 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: stable <stable@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Message-ID: <de6b1419-6bbd-4ad2-8b1e-dc989c7beba5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, A20 has been done inside the caches since 486, usually in the TLB.  Nehalem finally killed off A20M.

You're not the only one surprised by this...

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Wed, Dec 19, 2012 at 12:22 PM, H. Peter Anvin <hpa@linux.intel.com>
>wrote:
>>       x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI
>laptops
>
>Christ really? What century are we in? There are still machines that
>have A20 disabled at all, much less externally? How do they even do
>that these days, afaik the CPU caches can't handle the fake aliasing
>anyway..
>
>Anyway, pulled, I just wanted to express my surprise..
>
>          Linus

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
