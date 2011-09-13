Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab1IMW0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab1IMW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:26:11 -0400
Subject: Re: [PATCH 06/24] C6X: devicetree
From: Mark Salter <msalter@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Sep 2011 18:26:03 -0400
In-Reply-To: <CACxGe6tVafwVN6vdU7sCxL5JM7+as0bp_AaHaGAyE9+eTgR5Tw@mail.gmail.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <6360771.ouEC5EKNMR@wuerfel> <1315917546.11280.38.camel@deneb.redhat.com>
	 <201109131733.59700.arnd@arndb.de>
	 <CACxGe6tVafwVN6vdU7sCxL5JM7+as0bp_AaHaGAyE9+eTgR5Tw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315952764.11280.49.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 11:54 -0600, Grant Likely wrote:
> On Tue, Sep 13, 2011 at 9:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 13 September 2011, Mark Salter wrote:
> >> On Tue, 2011-09-13 at 08:43 +0200, Arnd Bergmann wrote:
> >> > Are these instructions specific to the interrupt controller or
> >> > do they access a register space that can contain arbitrary
> >> > devices?
> >> >
> >> > If there is a separate address space for special devices, it might
> >> > be good to describe that in the device tree, like we do for PCI
> >> > I/O space.
> >> >
> >>
> >> It is a core register area. Similar to ARM or MIPS coprocessor
> >> registers.
> >
> > I guess it still depends, it's probably a grey area. If the register layout
> > is the same on all c6x cores and it's only for core stuff, there is no need
> > to put it in the device tree. If you have multiple soc (off-core) devices
> > being controlled through the registers, or the numbers vary a lot between
> > different chips, I would put all of them into the device tree.
> 
> It's an interrupt controller.  There still needs to be a node to act
> as the interrupt-parent and specify #interrupt-cells.

It already has that. But maybe that node should be moved into the cpu
node.

--Mark


