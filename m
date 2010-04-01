Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0DAVmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:42:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DAVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:42:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: 2.6.31 regression: programs crashing after a couple of days of uptime with hibernation
Date: Thu, 1 Apr 2010 23:45:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004012332.49454.linux@rainbow-software.org>
In-Reply-To: <201004012332.49454.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012345.33124.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Ondrej Zary wrote:
> Hello,
> with kernel 2.6.30, I can have uptime of more than a month on my desktop PC
> (with hibernation). It's impossible with 2.6.31. After 1 to 3 days, processes
> that were running during hibernation (e.g. konsole, kwin, kicker, xorg) start
> to crash randomly in very weird ways. The kernel itself does not seem to
> crash. When I run the crashed program again, it seems to work. Looks like
> some memory corruption.
> 
> This bug is also present in 2.6.32 and 2.6.33.

Is the kernel 32-bit or 64-bit?  What kind of CPU is there in the box?

Rafael
