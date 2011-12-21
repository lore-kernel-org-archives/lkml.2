Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1LUQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:31:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33539 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1LUQbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:31:10 -0500
Message-ID: <1324485047.10752.20.camel@twins>
Subject: Re: [RFC][PATCH 7/7] serial, 8250: Mostly avoid wakeups from under
 port->lock
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 17:30:47 +0100
In-Reply-To: <1324484554.10752.16.camel@twins>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.678537446@chello.nl>
	 <20111221160323.1084e954@pyramind.ukuu.org.uk>
	 <1324484554.10752.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 17:22 +0100, Peter Zijlstra wrote:

> Could you explain that more, its not actually connecting with any
> neurons..

Note that I don't actually know how uarts work. So telling me to go read
that fine^Weffin' manual/wikipedia page is a good option.

I found me this page:

 http://www.lammertbies.nl/comm/info/serial-uart.html

and I guess I'll read it and pay extra attention to the flow control
part, since I found in serial_core.h that x_char is xon/xoff related.
