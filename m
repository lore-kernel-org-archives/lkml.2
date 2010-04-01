Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0DAVtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:49:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0DAVtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:49:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: S2RAM broken on HP 8530p
Date: Thu, 1 Apr 2010 23:52:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop> <201004012208.37540.rjw@sisk.pl> <alpine.DEB.2.00.1004011725540.2043@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1004011725540.2043@parag-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012352.18149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Parag Warudkar wrote:
> 
> On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> 
> > Please try:
> > 
> > # echo devices > /sys/power/pm_test
> > # echo mem > /sys/power/state
> > 
> > and see if that breaks too (it should get back to the command line in about
> > 5-10 seconds).
> 
> That breaks too - hangs similarly during suspend. I enabled RTC tracing 
> and every time it prints out different hash matches after reboot - 
> tty/tty21, pcie04  and latest is 
> 
> [    0.865296] pcieport 0000:00:1c.1: hash matches
> 
> Also when the suspend fails the immediate boot after that I get a USB 
> error on startup - unable to enumerate usb device on port 1. This error is 
> not present on normal boots.

Well, try the above with the USB controller drivers unloaded.

Rafael
