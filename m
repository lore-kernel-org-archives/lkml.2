Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0EVVw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 17:52:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab0EVVwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 17:52:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-wireless@vger.kernel.org
Subject: [Regression][git head f4b87dee9] ath9k doesn't work correctly after resume from suspend to RAM
Date: Sat, 22 May 2010 23:53:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005222353.26920.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With current -git on Acer Ferrari One the ath9k driver doesn't seem to work
after resume from suspend to RAM.  NetworkManager seems to think that it works,
but it doesn't really connect with the AP and doesn't try to obtain an IP
address.  Reloading the driver makes it work again.

The 2.6.34 (final) version works flawlessly with STR.

The user space is openSUSE 11.3 Milestone 6, so it may be somewhat unstable
in general, but this particular feature does work with 2.6.34.

Thanks,
Rafael
