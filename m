Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1ITSh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:37:58 -0400
Received: from seven.medozas.de ([188.40.89.202]:55603 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1ITSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:37:57 -0400
Date: Tue, 20 Sep 2011 20:37:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
In-Reply-To: <CAMuHMdUXw5nAsk0zYqU=fao2zgbPjg7f_LRCnr_Fa4MAQtWRWQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1109202017001.12921@frira.zrqbmnf.qr>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com> <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.
 <CAMuHMdUXw5nAsk0zYqU=fao2zgbPjg7f_LRCnr_Fa4MAQtWRWQ@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2011-08-30 09:00, Geert Uytterhoeven wrote:
>
>"Furthermore, there are users who seem more willing to port code known 
>to not be 64-bit clean to x32 than to do a whole new port."

Not to forget, there are qualified developers who are more than willing 
to port your code (known to not be 64-bit clean) to arbitrary 64-bit 
architectures, and properly so.
