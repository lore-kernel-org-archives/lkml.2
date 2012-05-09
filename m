Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2EIRid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:38:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44886 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2EIRic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:38:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120506132413.28499956@pyramind.ukuu.org.uk>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
	<20120505115851.1fecbe50@pyramind.ukuu.org.uk>
	<Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
	<20120506132413.28499956@pyramind.ukuu.org.uk>
Date: Wed, 9 May 2012 10:38:30 -0700
Message-ID: <CAP6odjhVK0PjXQ_vLbK2dWs4CnnxJwmhcDPDV=qLJmxBMBBDJQ@mail.gmail.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
From: Grant Grundler <grantgrundler@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 5:24 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> What NO_IRQ problem do you mean? There is
>> #define NO_IRQ          (-1)
>> in arch/parisc/include/asm/irq.h.
>
> It should be zero ready for us to get rid of it. Aa far as I can tell
> pa-risc can just move to 0 without anything breaking. In fact some stuff
> like serial port polling on 8250 ports will begin to work if it's done.

Alan,
Didn't this patch of yours go in?
    http://www.spinics.net/lists/linux-parisc/msg03894.html

And it's amusing to read linus' previous rants on this issue from 2005:
    http://lkml.indiana.edu/hypermail/linux/kernel/0511.2/1720.html
    http://lkml.indiana.edu/hypermail/linux/kernel/0511.2/1741.html
    http://lkml.indiana.edu/hypermail/linux/kernel/0511.2/1845.html

cheers,
grant
