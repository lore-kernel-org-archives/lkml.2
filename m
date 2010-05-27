Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab0E0RiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:38:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab0E0RiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:38:02 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271329460.3239-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1005271329460.3239-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:37:51 +0200
Message-ID: <1274981871.27810.5650.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 13:32 -0400, Alan Stern wrote:

> On some platforms (like those with ACPI), deeper power-savings are
> available by using forced suspend than by using idle. 

Sounds like something that's fixable, doesn't it?

>  That used to be
> the case on Android.  Arve has said that it isn't necessarily true any
> more, but that's the way their software is set up.

Who cares about their current software? We're arguing about sensible
interfaces for the technical problem posed.


