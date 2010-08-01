Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0HAXMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:12:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0HAXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:12:14 -0400
Date: Sun, 1 Aug 2010 16:12:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801161212.23a5d043@infradead.org>
In-Reply-To: <201008020102.24674.rjw@sisk.pl>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<201008020102.24674.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 01:02:24 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> Generally speaking, you can divide applications into the ones that
> will be allowed to influence ths system's behavior with respect to
> power management and the others that won't be allowed to do it.  The
> latter may be forcibly "frozen" (this way or another) when the
> "trused" ones collectively decide it's a good idea to enter a deeper
> "energy saving" state.  However, it is not a given that specific
> applications will always be in the same group.  They may be "trusted"
> on some systems and they may not be "trusted" on some other system,
> depending on the configuration etc.  That even may change over time
> on the same system.
> 

it might even be a sliding scale; the voting rights don't have to be
"0" and "1", but could also be "0.2" and such.... 
