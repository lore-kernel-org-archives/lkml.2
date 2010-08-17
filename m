Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0HQRNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:13:54 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60662 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0HQRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ap2QYS5CeGZ2DtgLYvAeX1Wr53vcpE6BtObUhzK5sds1MwqaAhIrRvfgt/FCPKqQ+4
         6kmTBeju28jNC4OV431RHyHz/7/K154vITwBLi1dpmXCAZPIPe5hd31fWLYwyhuOtgVQ
         w0skSq27TKjnYlTw+shoqCRMhA3cvK/xlYqGI=
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Habets <thomas@habets.pp.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
In-Reply-To: <alpine.DEB.1.10.1008171737260.21857@red.crap.retrofitta.se>
References: <alpine.DEB.1.10.1008131952470.19570@red.crap.retrofitta.se>
	 <1281953960.2524.23.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008161224510.13728@red.crap.retrofitta.se>
	 <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se>
	 <1282024802.2487.687.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se>
	 <1282050920.2448.47.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se>
	 <1282055659.2448.58.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008171737260.21857@red.crap.retrofitta.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 19:13:47 +0200
Message-ID: <1282065227.2448.116.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 17:58 +0200, Thomas Habets a écrit :

> If you expected more bits set in "filters" with allmulti than without it, 
> that doesn't seem to be the case.


Nope, the patch displays mc list and filters bits only if not
promiscuous and not allmulti (normal ethernet mode)

If promiscuous -> a special PROMISC bit is selected on NIC (no display)
If allmulti -> all 128 bits are set (but not displayed in my patch)

I wanted to make sure the correct list of mc addrs is handled on your
machine. It seems to be the case, so there might be a hardware problem
with the multicast rx on this particular NIC



