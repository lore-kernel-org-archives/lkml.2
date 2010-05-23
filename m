Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0EWTTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 15:19:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab0EWTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 15:19:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [Regression][git head f4b87dee9] ath9k doesn't work correctly after resume from suspend to RAM
Date: Sun, 23 May 2010 21:20:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201005222353.26920.rjw@sisk.pl> <201005230013.37578.rjw@sisk.pl>
In-Reply-To: <201005230013.37578.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005232120.16814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 May 2010, Rafael J. Wysocki wrote:
> On Saturday 22 May 2010, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > With current -git on Acer Ferrari One the ath9k driver doesn't seem to work
> > after resume from suspend to RAM.  NetworkManager seems to think that it works,
> > but it doesn't really connect with the AP and doesn't try to obtain an IP
> > address.
> 
> Sorry, this was incorrect.  It actually tries to obtain an IP address, but
> fails.  Apparently, it can't obtain the address without being reloaded.

iwlagn also has problems after resume from suspend to RAM (tested on
Toshiba Portege R500).  In this case resume works once, but then the next
attempt to suspend fails (I had to reboot the box every time that happened).

If iwlagn is unloaded, it is possible to suspend and resume the system
arbitrary number of times, but then iwlagn doesn't work when its reloaded
(it doesn't detect wireless networks).

Rafael
