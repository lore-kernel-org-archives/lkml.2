Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1CALni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:43:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab1CALng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:43:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
Date: Tue, 1 Mar 2011 12:43:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <201103011127.51605.arnd@arndb.de> <20110301111220.GN29521@pengutronix.de>
In-Reply-To: <20110301111220.GN29521@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011243.33765.arnd@arndb.de>
X-Provags-ID: V02:K0:fZRPXftdgsEIaA3+5+vEYgvnSN4Y9h1PMtTnMGP21g3
 Gk7vww/iQWLWHWn9ZW8+hkg0+yJ1iZwD7NuQhfREDQKNU4MFdc
 Lyz49Y6vXUrWsv53cmB7OJ88WKSdljxAHcA2HA3hkOy2WHdzQX
 wYEhQHo48aot0BP/Ih++20bjqFcQwaEOK8+/0i94pGKc05P6PX
 DmLfNGxGpI8MTdG2k+0cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 March 2011, Sascha Hauer wrote:
> > Taking one step back from this, have you considered making this
> > a regular interrupt controller? That would make the client drivers
> > more standard -- you could define the interrupt numbers as resources
> > of a platform device or in the device tree, for instance.
> > The cost might be more complex code, e.g. when a device requires
> > many interrupts, but I think it will be at least as efficient
> > at run-time, and less surprising for readers and authors of
> > client drivers.
> 
> I thought about this, but hesitated to increase NR_IRQS by 463. Do you
> think we should do this instead?

I think there is a plan to virtualize the interrupt numbers on ARM,
and in that case NR_IRQS becomes rather meaningless. I don't know
exactly how far that effort has come.

	Arnd
