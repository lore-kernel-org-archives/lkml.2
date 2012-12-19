Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2LSVCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:02:37 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:39929 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2LSVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <201212192022.qBJKMrJ6021946@tazenda.hos.anvin.org>
References: <201212192022.qBJKMrJ6021946@tazenda.hos.anvin.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Dec 2012 13:02:09 -0800
X-Google-Sender-Auth: 8bO0qhfbqvFtaY27cLxz2sBhIj0
Message-ID: <CA+55aFxeOK5mvuLubtdRLGrnX3waY=wBisFFE49b-nSwGiLaKg@mail.gmail.com>
Subject: Re: [GIT PULL] Additional x86 fixes for v3.8-rc1
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: stable <stable@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:22 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>       x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Christ really? What century are we in? There are still machines that
have A20 disabled at all, much less externally? How do they even do
that these days, afaik the CPU caches can't handle the fake aliasing
anyway..

Anyway, pulled, I just wanted to express my surprise..

          Linus
