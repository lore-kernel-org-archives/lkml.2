Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030409Ab2CIUcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:32:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:47371 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2CIUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:32:01 -0500
Date: Fri, 9 Mar 2012 21:31:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>
Subject: Re: udelay minimum delay guarantee and maximum supported delay?
In-Reply-To: <CA+55aFz5mt1LWDVVdPD3vsE4F1u8+Rz5j1fh69de0f5ae-cbNw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203092131420.2742@ionos>
References: <201203091437.50996.tvrtko.ursulin@onelan.co.uk> <alpine.LFD.2.02.1203091855350.2742@ionos> <CA+55aFz5mt1LWDVVdPD3vsE4F1u8+Rz5j1fh69de0f5ae-cbNw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Linus Torvalds wrote:

> On Fri, Mar 9, 2012 at 11:55 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Make those variables explicitely u32 again, so this works for both 32
> > and 64 bit.
> 
> Ack. Should I take this directly?

Sure.
