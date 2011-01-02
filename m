Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1ABLdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:33:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53006 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1ABLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fw/Baepvj3vARlO6SqnJmolVwLpeBb8CGXHaVyLPXvAjLaJWFPnuu8m19XJolGwNm/
         Kv6QXXy+pNC6Puvh+I7cdFZmu3amn9ibbLePGf5JvHPdw+tnUVTNyXXwoypBSRf/WZQA
         a9+bsZ11TluGNDCtY6nIRufXo+mCIj8P5Fo4I=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1293967023.29525.16.camel@wall-e>
References: <1293918276-28773-1-git-send-email-stefani@seibold.net>
	 <1293920601.2535.64.camel@edumazet-laptop>
	 <1293967023.29525.16.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 12:33:16 +0100
Message-ID: <1293967996.2535.76.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 12:17 +0100, Stefani Seibold a écrit :
> Am Samstag, den 01.01.2011, 23:23 +0100 schrieb Eric Dumazet:

> > 3) I see UDPLITE references in your code. Are you sure UDPCP protocol
> > can really work on top of UDPLITE ? I think not, so please remove dead
> > code.
> > 
> 
> I have not tested it yet. But i think i should work, the code is mostly
> stolen from the udp.c file. Since the stack not depend on the len field
> of the UDP header, it should not matter if UPD or UDP-Lite is used.
> 

Hmm, but isnt your :

udpcp_prot = udp_prot; /* in udpcp_init() */

implies that all UDPCP sockets you are going to provide to user are on
top of UDP, not UDPLITE ?

Also, could you provide a link to UDPCP protocol specs ?

Thanks


