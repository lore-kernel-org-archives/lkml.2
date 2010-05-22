Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab0EVWMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 18:12:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59030 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808Ab0EVWMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 18:12:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-wireless@vger.kernel.org
Subject: Re: [Regression][git head f4b87dee9] ath9k doesn't work correctly after resume from suspend to RAM
Date: Sun, 23 May 2010 00:13:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201005222353.26920.rjw@sisk.pl>
In-Reply-To: <201005222353.26920.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005230013.37578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Rafael J. Wysocki wrote:
> Hi,
> 
> With current -git on Acer Ferrari One the ath9k driver doesn't seem to work
> after resume from suspend to RAM.  NetworkManager seems to think that it works,
> but it doesn't really connect with the AP and doesn't try to obtain an IP
> address.

Sorry, this was incorrect.  It actually tries to obtain an IP address, but
fails.  Apparently, it can't obtain the address without being reloaded.

Rafael
