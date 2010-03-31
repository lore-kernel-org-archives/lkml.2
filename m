Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0CaJ7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:59:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54001 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933077Ab0CaJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:59:09 -0400
Date: Wed, 31 Mar 2010 11:02:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Message-ID: <20100331110228.2443ccd6@lxorguk.ukuu.org.uk>
In-Reply-To: <201003310957.03025.arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
	<20100330233759.00877e80@lxorguk.ukuu.org.uk>
	<201003310957.03025.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you more worried that the interface conversion (patches 1-8)
> can introduce bugs and make your life harder, or that the mutex
> based implementation from patch 9 causes problems that were previously
> hidden by other bugs?

It doesn't really make any difference to me - I'm either removing the BKL
or the BKM.

Alan
