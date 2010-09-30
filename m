Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0I3LxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:53:04 -0400
Received: from mail.southpole.se ([193.12.106.18]:46223 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab0I3LxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:53:02 -0400
Subject: Re: ioremap definition in generic io.h
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201009301345.16817.arnd@arndb.de>
References: <1285747145.12259.3.camel@needafix> <4CA31AA6.7020003@gmail.com>
	 <1285758446.12259.9.camel@needafix>  <201009301345.16817.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Thu, 30 Sep 2010 13:52:59 +0200
Message-ID: <1285847579.2639.3.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 13:45 +0200, Arnd Bergmann wrote:
> On Wednesday 29 September 2010, Jonas Bonn wrote:
> > On another note, looking at the definitions of ioread32/iowrite32, they
> > imply a little-endian bus.  Some architectures (e.g. Microblaze) define
> > these to use host-native byte ordering instead.  Is there a correct
> > way these functions should be defined?
> 
> ioread32/iowrite32 are accessor functions for PCI byte order which is
> little endian. If microblaze does this differently, that is a microblaze
> bug. Any code that needs big-endian I/O should use ioread32be/iowrite32be.
> 

So what's the correct way to do host-native access?  For example, big
endian access on a big endian processor.  I think I'm missing something
fundamental here...

/Jonas

