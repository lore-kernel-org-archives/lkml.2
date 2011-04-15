Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1DOVJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:09:46 -0400
Received: from mail.sdinet.de ([78.47.32.153]:34219 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab1DOVJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:09:45 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 17:09:45 EDT
Date: Fri, 15 Apr 2011 23:00:45 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
X-X-Sender: haegar@aurora
To: Greg KH <gregkh@suse.de>
cc: Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.32.37
In-Reply-To: <20110415164914.GA10357@kroah.com>
Message-ID: <alpine.DEB.2.02.1104152256340.7559@aurora>
References: <20110415164914.GA10357@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Greg KH wrote:

> I'm announcing the release of the 2.6.32.37 kernel.

> Vasiliy Kulikov (13):
>       net: ax25: fix information leak to userland

2.6.32.37 contains fe10ae53384e48c51996941b7720ee16995cbcb7, but seems 
to miss 5b919f833d9d60588d026ad82d17f17e8872c7a9 which fixes this fix.

(Found by checking why Ubuntu had a different fix here than 2.6.32.37)

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
