Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1FPRI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:08:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43361 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1FPRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:08:28 -0400
Date: Thu, 16 Jun 2011 18:07:54 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: Dynamic patching in discarded sections
Message-ID: <20110616170754.GA30370@arm.com>
References: <201106081123.59414.arnd@arndb.de>
 <alpine.LFD.2.00.1106080946000.2142@xanadu.home>
 <201106161721.27330.arnd@arndb.de>
 <201106161725.03366.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106161725.03366.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:25:03PM +0200, Arnd Bergmann wrote:
> On Thursday 16 June 2011, Arnd Bergmann wrote:
> > 10000 randconfig kernel build later without that patch, I'm rather sure
> > that there is only a single driver that is suffering from this. While your
> > patch absolutely makes sense, a less invasive workaround would be to just
> > not mark mmc_spi_remove as __devexit until Dave's patch gets in.
> 
> Scratch that. Even when Dave's patch gets into binutils, we'd still need to
> make a compile time decision to figure out if the linker is new enough, so
> we definitely need Nicolas' patch as well.
> 
> 	Arnd

It would be nice to get it merged for the longer term, but we'll have
quite a long transitional period while the change propagates.

So we'd still need some other workaround for now.

Cheers
---Dave

