Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1IUWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:13:57 -0400
Received: from plane.gmane.org ([80.91.229.3]:38159 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1IUWNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,419,1312182000"; 
   d="scan'208";a="59079805"
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <public-arnd-r2nGTMty4D4@plane.gmane.org>
Cc: Wolfgang Grandegger 
	<public-wg-5Yr1BZd7O62+XT7JhA+gdA@plane.gmane.org>,
        SocketCAN Core Mailing List 
	<public-socketcan-core-0fE9KPoRgkgATYTw5x5z8w@plane.gmane.org>,
        Willy Lambert 
	<public-lambert.willy-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        public-x86-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org,
        public-Valdis.Kletnieks-PjAqaU27lzQ@plane.gmane.org,
        LKML <public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
References: <4E731565.5050307@grandegger.com>
	<201109201747.50130.arnd@arndb.de> <4E79A146.2040204@grandegger.com>
	<11382509.BgAkVknI9a@wuerfel>
Date: Wed, 21 Sep 2011 15:13:42 -0700
In-Reply-To: <11382509.BgAkVknI9a@wuerfel> (Arnd Bergmann's message of "Wed,
	21 Sep 2011 11:24:44 +0200")
Message-ID: <m239fpee7d.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> writes:
>
> The other point is that you are probably using inb/outb operations,
> which I'm trying to provide only on ISA/PCMCIA/PCI based systems in
> the future. Once I finish that work, you will also need to depend on
> HAS_IOPORT (which currently means something else).

What does that mean? Most PCs need at least some ioport usage
during boot.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

