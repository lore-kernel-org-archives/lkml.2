Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CHUKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:10:11 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:44343 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1CHUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:10:09 -0500
X-IronPort-AV: E=Sophos;i="4.62,285,1297036800"; 
   d="scan'208";a="4681058"
Date: Tue, 8 Mar 2011 20:09:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
In-Reply-To: <AANLkTinkA5UNfdAqhnJYgC+czPrNYtOtfY332JCvZXy-@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103081913560.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop> <4D6D6980.7060304@kernel.org> <alpine.DEB.2.00.1103071527500.2968@kaball-desktop> <AANLkTi=aUGdjvtvy81FimMZB5PZNzASXHN0BZHWHUuLs@mail.gmail.com> <alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
 <AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com> <alpine.DEB.2.00.1103081728300.2968@kaball-desktop> <AANLkTinkA5UNfdAqhnJYgC+czPrNYtOtfY332JCvZXy-@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, Yinghai Lu wrote:
> [    0.000000] kernel direct mapping tables up to 7f750000 @
> [0x7f74c000-0x7f74ffff] pre-allocated
> [    0.000000] DEBUG map_low_page phys    243a000
> [    0.000000] DEBUG map_low_page phys    243e000
> [    0.000000] DEBUG alloc_low_page phys   7f74c000
> [    0.000000] DEBUG map_low_page phys    243a000
> [    0.000000] DEBUG map_low_page phys   7f74c000
> [    0.000000] DEBUG alloc_low_page phys   7f74d000
> 

I couldn't see this on my machine but I was afraid it could happen on
some hardware :(
Thank you very much for spending your time on this and for your kind
replies.
I'll follow up with an update of the xen specific patch I posted before
and I won't bother you again with this :)
Cheers,

Stefano
