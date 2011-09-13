Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1IMPeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1IMPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:34:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 06/24] C6X: devicetree
Date: Tue, 13 Sep 2011 17:33:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
References: <1314826019-22330-1-git-send-email-msalter@redhat.com> <6360771.ouEC5EKNMR@wuerfel> <1315917546.11280.38.camel@deneb.redhat.com>
In-Reply-To: <1315917546.11280.38.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131733.59700.arnd@arndb.de>
X-Provags-ID: V02:K0:AJ2fmK9yqKv6PZsp73Z/XUg2bGaX8JkITzE7PbB7zWy
 4fWOHiSJ8nQA6vI1uNyvjYvNyaRP3IGLBXQRDFlNbN1kpnLQ3U
 9gKteByAIu0kTbTqd6Sf2UtUNLtQ9jkTFO+nz1sYCM+Wdknuhf
 msqGYq4mhF6MH1kEIkRrFd47HDFI4oip/ShLbd/pqsN/emNC7s
 yxB7QMzMQis5kJJ2/jDmnLi9Yv4+WtpE/gANsLUxrAhWB/wppW
 zQEm1uohfnmAww4gHGw+d0RFA4Dvl4u45KjFhwAeFtYmKhJ16a
 PymmsnNbV6sjxzGCieqjnqW/ux8UDe10FJIYNtmrx1BlJjGmfy
 AQ5YK+mHR5gWOq+nJ1Q8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 September 2011, Mark Salter wrote:
> On Tue, 2011-09-13 at 08:43 +0200, Arnd Bergmann wrote:
> > Are these instructions specific to the interrupt controller or
> > do they access a register space that can contain arbitrary
> > devices?
> > 
> > If there is a separate address space for special devices, it might
> > be good to describe that in the device tree, like we do for PCI
> > I/O space.
> > 
> 
> It is a core register area. Similar to ARM or MIPS coprocessor
> registers.

I guess it still depends, it's probably a grey area. If the register layout
is the same on all c6x cores and it's only for core stuff, there is no need
to put it in the device tree. If you have multiple soc (off-core) devices
being controlled through the registers, or the numbers vary a lot between
different chips, I would put all of them into the device tree.

	Arnd
