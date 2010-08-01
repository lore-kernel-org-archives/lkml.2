Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0HAEwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 00:52:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:58366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0HAEwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 00:52:32 -0400
Date: Sat, 31 Jul 2010 21:52:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100731215214.2543c07e@infradead.org>
In-Reply-To: <20100731175841.GA9367@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
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

On Sat, 31 Jul 2010 10:58:42 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> o	"Power-aware application" are applications that are permitted
> 	to acquire suspend blockers on Android.  Verion 8 of the
> 	suspend-blocker patch seems to use group permissions to
> determine which applications are classified as power aware.
> 
> 	More generally, power-aware applications seem to be those that
> 	have permission to exert some control over the system's
> 	power state.

I don't like the term "Power aware application". An application is well
behaved or it isn't. "aware" has nothing to do with it.


> 
> REQUIREMENTS
> 
> o	Reduce the system's power consumption in order to (1) extend
> 	battery life and (2) preserve state until AC power can be
> obtained.

AC power is not relevant in discussions around power: Applications MUST
behave well, AC or DC both. Just ask any data center operator on how
much they run on DC and if he cares about power consumption.
Conversely, most mobile usages (both phone, tablet or netbook) are "DC
only"....





 
> o	It is necessary to be able to use power-naive applications.
> 	Many of these applications were designed for use in PC
> platforms where power consumption has historically not been of great
> 	concern, due to either (1) the availability of AC power or (2)
> 	relatively undemanding laptop battery-lifetime expectations.
> The system must be capable of running these power-naive applications
> 	without requiring that these applications be modified, and
> must be capable of reasonable power efficiency even when power-naive
> 	applications are available.

I don't buy this argument as is.

I do buy that there are many sloppy applications; mostly written quickly
for <appstore of the month>.  But most if not all of these are written
for the device in question (at least that is true for Apple and Android)



