Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2ETQD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:03:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:56067 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2ETQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:03:58 -0400
Date: Sun, 20 May 2012 18:03:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anna-Maria Gleixner <anna-maria@glx-um.de>
cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/24] timers: Provide generic Kconfig switches
In-Reply-To: <1337529587.3208.2.camel@dionysos>
Message-ID: <alpine.LFD.2.02.1205201802500.3231@ionos>
References: <20120518163020.548627576@glx-um.de>  <20120518163104.499615021@glx-um.de>  <20120518231432.GH24355@linux-sh.org> <1337529587.3208.2.camel@dionysos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Anna-Maria Gleixner wrote:
> On Sat, 2012-05-19 at 08:14 +0900, Paul Mundt wrote:
> > On Fri, May 18, 2012 at 04:45:43PM -0000, Anna-Maria Gleixner wrote:
> > > +# Clockevents broadcasting infrastructure
> > > +config GENERIC_CLOCKEVENTS_BROADCAST
> > > +	bool
> > > +	depends on GENERIC_CLOCKEVENTS
> > > 
> > Looks like you've missed GENERIC_CMOS_UPDATE.
> 
> Looks like the author of the patch missed it. Find an updated version
> below.

You can whack that guy if you meet him. :)

