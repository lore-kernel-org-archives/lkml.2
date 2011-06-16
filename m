Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1FPRlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:41:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52838 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab1FPRlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:41:04 -0400
Date: Thu, 16 Jun 2011 13:41:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Dave Martin <dave.martin@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Dynamic patching in discarded sections
In-Reply-To: <20110616170754.GA30370@arm.com>
Message-ID: <alpine.LFD.2.00.1106161339111.2142@xanadu.home>
References: <201106081123.59414.arnd@arndb.de> <alpine.LFD.2.00.1106080946000.2142@xanadu.home> <201106161721.27330.arnd@arndb.de> <201106161725.03366.arnd@arndb.de> <20110616170754.GA30370@arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Dave Martin wrote:

> On Thu, Jun 16, 2011 at 05:25:03PM +0200, Arnd Bergmann wrote:
> > On Thursday 16 June 2011, Arnd Bergmann wrote:
> > > 10000 randconfig kernel build later without that patch, I'm rather sure
> > > that there is only a single driver that is suffering from this. While your
> > > patch absolutely makes sense, a less invasive workaround would be to just
> > > not mark mmc_spi_remove as __devexit until Dave's patch gets in.
> > 
> > Scratch that. Even when Dave's patch gets into binutils, we'd still need to
> > make a compile time decision to figure out if the linker is new enough, so
> > we definitely need Nicolas' patch as well.
> > 
> > 	Arnd
> 
> It would be nice to get it merged for the longer term, but we'll have
> quite a long transitional period while the change propagates.

That is assuming such a change gets merged to start with.


Nicolas
