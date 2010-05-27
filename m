Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0E0RgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:36:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab0E0RgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:36:05 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527173218.GF2468@srcf.ucam.org>
References: <20100527155201.GA31937@srcf.ucam.org>
	 <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
	 <20100527161943.GA32764@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
	 <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins>
	 <20100527171644.GA2468@srcf.ucam.org> <1274980856.27810.5582.camel@twins>
	 <20100527172510.GC2468@srcf.ucam.org> <1274981288.27810.5609.camel@twins>
	 <20100527173218.GF2468@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:35:50 +0200
Message-ID: <1274981750.27810.5641.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:32 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:28:08PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 18:25 +0100, Matthew Garrett wrote:
> > > How (and why) does the WoL (which may be *any* packet, not just a magic 
> > > one) turn the screen back on?
> > 
> > Why would you care about the screen for a network event?
> 
> Because the application that needs to handle the network packet is 
> currently blocked trying to draw something to the screen.

Then that's an application bug right there, isn't it?

If should have listened to the window server telling its clients it was
going to go away. Drawing after you get that is your own damn fault ;-)
