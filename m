Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1FIAZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:25:21 -0400
Received: from lunge.queued.net ([66.23.231.200]:49543 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1FIAZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:25:19 -0400
Date: Wed, 8 Jun 2011 17:25:14 -0700
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Drake <dsd@laptop.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook
 switch functionality
Message-ID: <20110608172514.5ca5b2ce@queued.net>
In-Reply-To: <BANLkTiny5hKo3BRxCB-hNJTNYbvcfHkviw@mail.gmail.com>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
	<1304166750-31125-8-git-send-email-dsd@laptop.org>
	<20110516090813.GA26487@linutronix.de>
	<BANLkTimpFYMpQFY9J7pa0NygGoQ8dLdArA@mail.gmail.com>
	<4DE4D0EE.20907@linutronix.de>
	<BANLkTiny5hKo3BRxCB-hNJTNYbvcfHkviw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 21:48:17 +0100
Daniel Drake <dsd@laptop.org> wrote:

> On 31 May 2011 12:28, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > Is this something like pin multiplexing? So it is either a GPIO pin
> > with interrupt ability _or_ that PME thingy.
> 
> No, it's not multiplexing in that sense. It is either a GPIO that
> generates an interrupt, or a GPIO that generates a PME.
> 
> We use it for both its PME functionality and its GPIO functionality.
> 

So what's the status of this series at this point?  Is there any
reason to keep them out of x86 tip?  We've got an Ack from Grant so
far..
