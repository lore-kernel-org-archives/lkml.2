Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2BDOg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:36:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44205 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751226Ab2BDOg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:36:56 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19M8uAinZhMWnTl7vG4zdSf4WgiZ1Iow+TCZw9QKE
	5z4yiJvbLs7SjA
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: swap storm since kernel 3.2.x
Date: Sat, 4 Feb 2012 15:36:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.3; KDE/4.8.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201202041109.53003.toralf.foerster@gmx.de> <20120204133331.GA13223@sig21.net>
In-Reply-To: <20120204133331.GA13223@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202041536.52189.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Johannes Stezenbach wrote at 14:33:31
> On Sat, Feb 04, 2012 at 11:09:52AM +0100, Toralf Förster wrote:
> > Within the last few weeks I'm observing sometimes a swap storm at my
> > ThinkPad while compiling/installing new packages at my Gentoo Linux -
> > the load is often something like :
> > 
> > Load avg: 13.6, 20.6, 20.9
> > 
> > I'm wondering whether this is related to kernel 3.2.x /Gentoo specific or
> > related to my system only.
> 
> Do you happen to have CONFIG_DEBUG_OBJECTS enabled?  For me it
> ate lots of memory with 3.2.2, easily visible in slabtop.
> 
> 
> Johannes

No, I've these settings :

tfoerste@n22 ~ $ zgrep -e OBJ -e SLAB -e SLUB /proc/config.gz  | grep -v '#'
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
CONFIG_SLABINFO=y

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
