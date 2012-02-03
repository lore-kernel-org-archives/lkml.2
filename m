Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2BCB73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:59:29 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43089 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab2BCB71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:59:27 -0500
Date: Thu, 2 Feb 2012 20:59:25 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Palmer <chris.palmer@pobox.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org, keve@irb.hu,
        bjorn.ottervik@gmail.com, kaneda@freemail.hu, clemens@ladisch.de,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems
Message-ID: <20120203015925.GA14359@Brahman>
References: <4E68A6E8.9020700@pobox.com>
 <20110908165155.f661a738.akpm@linux-foundation.org>
 <4F26B162.4050000@pobox.com>
 <4F274E28.2010200@gmail.com>
 <4F27D9AD.1020806@pobox.com>
 <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com>
 <CA+55aFytBRZiQUcnWtSYnxqXUJCfVuS4f5tq=QUNG2GfbF1mhA@mail.gmail.com>
 <CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com>
 <CAPRPZsB8MakxizGJuT7E9mEvdH6QT6fVzuckE0-yxi4RLD0xKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPRPZsB8MakxizGJuT7E9mEvdH6QT6fVzuckE0-yxi4RLD0xKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens and Jeroen - um, wow, that is a lot of strong thinking.  I
don't have any code in mind, to match, yet.  Especially given your set
of questions, Jeroen.  I'll try to get time to think and read the
code.  Hopefully the group will be ahead of my pace. :)

(I have a more minor patch for spurious.c, that I need to resubmit,
too, and I should probably get that over with, first.  So if you see
me post about "better error messages for spurious IRQs", it won't be
directly related to this.)

Thanks, 

Ed
