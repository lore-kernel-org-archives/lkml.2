Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966185Ab2DLWbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:31:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54058 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab2DLWbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204130022520.2542@ionos>
References: <alpine.LFD.2.02.1204130004080.2542@ionos> <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com>
 <alpine.LFD.2.02.1204130022520.2542@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Apr 2012 15:31:29 -0700
X-Google-Sender-Auth: IIyHrGvlpZRhZXlhda-V_A9AhMg
Message-ID: <CA+55aFzP-DmGUqGcnxj2mq-mvmOXA7k-zgOrdDRY3WA9N5dmBg@mail.gmail.com>
Subject: Re: [GIT pull] timer fixes for 3.4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 3:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> I ran it through all the various (outdated) distros I have handy and
> the printk didn't show once.
>
> I tried to figure out the reason for this NULL pointer thing, but
> there is no trace of it on the intarwebs at all.

Ok. If we don't see any reports of messages, we can certainly remove it.

That said, would people actually *report* those messages?

In general, for things like this, it's probably better to just make
the change (especially if you have several distros you can test), and
then add a printk_once() for the case that changed. Then, if people
actually report it as some program stopping to work, the dmesg
hopefully clues us in about the reason for the program not working.
But that would have needed to happen during the merge window, it's too
late now.

Whatever. We'll see if somebody reports the message.

                     Linus
