Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab1GBUQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 16:16:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab1GBUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 16:16:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 2/2] iomap: make IOPORT/PCI mapping functions conditional
Date: Sat, 2 Jul 2011 22:15:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309622006-28343-1-git-send-email-jonas@southpole.se> <201107022146.15854.arnd@arndb.de> <1309636466.24186.1439.camel@localhost>
In-Reply-To: <1309636466.24186.1439.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022215.47324.arnd@arndb.de>
X-Provags-ID: V02:K0:MBMyFjDq7NQuat1YfYmXl+5KuUQaj7DkRLw1gXTMGM7
 EUuC0QvCo/uXkpINqgUhTFihRhuRj7KNjCiRp5nl8KOLnOd8DO
 JduRWmdR7W1Use+CfBVkptXXzrUnaakU05ams4ShixvOkMYUcl
 0JRf5qigfwDiKGlzHeGmPnZtV3p712QuEvvXZ/H+5cQ/RGSBgY
 +AZk94G8EkZYgNpvvH7TQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 21:54:26 Jonas Bonn wrote:
> On Sat, 2011-07-02 at 21:46 +0200, Arnd Bergmann wrote:
> > On Saturday 02 July 2011 17:53:26 Jonas Bonn wrote:
> > > Use the CONFIG_HAS_IOPORT and CONFIG_PCI options to decide whether or
> > > not functions for mapping these areas are provided.
> > > 
> > > Signed-off-by: Jonas Bonn <jonas@southpole.se>
> > 
> > Good catch!
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Did you get a build error without the two options, or did you just have an
> > idea to save a bit of code size?
> > 
> 
> There was no build error; I just figured it would aid in debugging if
> you got a compile-time error when trying to build drivers that use these
> functions for a platform that lacked them.  Smaller code is always nice,
> too.

Right. Did you also see the related discussion at
http://lkml.org/lkml/2011/7/1/422 ?

	Arnd
