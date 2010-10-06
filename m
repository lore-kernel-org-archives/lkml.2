Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab0JFJKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:10:22 -0400
Received: from ozlabs.org ([203.10.76.45]:59231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0JFJKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:10:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Date: Wed, 6 Oct 2010 19:40:05 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <AANLkTinCgGDxhuUf1a+gO-xdVi9bU0Shmo-KejC+eU4o@mail.gmail.com> <alpine.LFD.2.00.1010051923140.2556@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010051923140.2556@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010061940.06351.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010 04:13:33 am Thomas Gleixner wrote:
> On Tue, 5 Oct 2010, Linus Torvalds wrote:
> > But hey, maybe I'm missing something really silly.
> 
> Nah. Works fine. Sorry for making you build modules :)
> 
> Tested-by: Thomas Gleixner <tglx@linutronix.de>

It's also much saner.  Thanks Linus!

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Rusty.
