Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0LVOhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:37:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0LVOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jgYaxNcrgoV482AO3OkSBOV0B2UVuQL9E444wKEgc9xKvRiMSbRci2bjxHuBNkvBVb
         MuJLGzuehB46jxRdht8fGYfOmIFsQ1Kjfrk60VEZ123xDnJ6eJxVfrMsEUIJIaa8Ah/V
         iIBRDLRuRXpRZB/FtTYM5+wFZYHqO8uFeeHQI=
Subject: Re: [PATCH] tcp: use RTAX_CWND for outgoing connections properly
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012221506500.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012172310400.16569@pobox.suse.cz>
	 <alpine.LNX.2.00.1012221059340.16569@pobox.suse.cz>
	 <1293017383.3027.75.camel@edumazet-laptop>
	 <alpine.LNX.2.00.1012221231450.16569@pobox.suse.cz>
	 <alpine.LNX.2.00.1012221506500.16569@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 15:37:01 +0100
Message-ID: <1293028621.3027.129.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 15:07 +0100, Jiri Kosina a écrit :

> 
> OK, so current vanilla (not even net-next needed) seems to correctly 
> handle initcwnd value and sends as many packets as fit into it, instead of 
> waiting after one or two MSS-sized packets. So someone already fixed it 
> in some other way apparently. Sorry for the noise.
> 

Indeed ;)

net-next was necessary at least for the other side, so that its SYNACK
packet advertizes a large enough window ;)



