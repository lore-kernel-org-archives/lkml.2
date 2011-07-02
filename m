Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab1GBTyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:54:36 -0400
Received: from mail.southpole.se ([193.12.106.18]:36398 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1GBTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:54:34 -0400
Subject: Re: [PATCH 2/2] iomap: make IOPORT/PCI mapping functions
 conditional
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <201107022146.15854.arnd@arndb.de>
References: <1309622006-28343-1-git-send-email-jonas@southpole.se>
	 <1309622006-28343-2-git-send-email-jonas@southpole.se>
	 <201107022146.15854.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sat, 02 Jul 2011 21:54:26 +0200
Message-ID: <1309636466.24186.1439.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2011-07-02 at 21:46 +0200, Arnd Bergmann wrote:
> On Saturday 02 July 2011 17:53:26 Jonas Bonn wrote:
> > Use the CONFIG_HAS_IOPORT and CONFIG_PCI options to decide whether or
> > not functions for mapping these areas are provided.
> > 
> > Signed-off-by: Jonas Bonn <jonas@southpole.se>
> 
> Good catch!
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Did you get a build error without the two options, or did you just have an
> idea to save a bit of code size?
> 

There was no build error; I just figured it would aid in debugging if
you got a compile-time error when trying to build drivers that use these
functions for a platform that lacked them.  Smaller code is always nice,
too.

/Jonas

