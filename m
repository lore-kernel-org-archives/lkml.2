Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0FJFLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:11:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab0FJFLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:11:12 -0400
Date: Thu, 10 Jun 2010 15:10:55 +1000
From: Neil Brown <neilb@suse.de>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: david@lang.hm, Alan Stern <stern@rowland.harvard.edu>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100610151055.5a0870ba@notabene.brown>
In-Reply-To: <AANLkTilrJYg-z6mbRfhhrDdhpWUYSXGQEMCGgBj24xZs@mail.gmail.com>
References: <AANLkTilALyvthzh8rMiDFFP_QTz_o5hxdE8tArMUonpP@mail.gmail.com>
	<Pine.LNX.4.44L0.1006091031030.1728-100000@iolanthe.rowland.org>
	<AANLkTil2JhBgJ27qcTARVj2wVgEltxZKPOc9Ddu4c8yY@mail.gmail.com>
	<alpine.DEB.2.01.1006092117100.17462@asgard.lang.hm>
	<AANLkTilrJYg-z6mbRfhhrDdhpWUYSXGQEMCGgBj24xZs@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 21:51:38 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> The current user space interface does not require that clients
> register the file descriptors that they get wakeup events from with
> another process.
> 

However I believe they *do* register these file descriptors with the kernel,
via some sort of ioctl (I think you have said that is the case for input
devices at least).
Can you confirm that?

If that is the case, is it really such a big change to register with another
process instead of with the kernel?

Thanks,
NeilBrown


