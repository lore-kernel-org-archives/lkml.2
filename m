Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0HZL5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:57:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39410 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0HZL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dp2xLLePE9fyxFXSvki7hBfk8iDHZKzXTNc/WQhGe3F2Jw2p/l1uEx26RnNqbCOpou
         s55zvSmPdPEzSdoLpgZZEmpCQuuRllnoZso04iYi+1ryssDalbhbDzvKhI6v0ea8KpJK
         w/8HnCT69/lzS975sxI8sA+awv9ggiqTTJyNA=
Subject: Re: RFC: MTU for serving NFS on Infiniband
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Marc Aurele La France <tsi@ualberta.ca>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <alpine.WNT.2.00.1008251408520.632@cluij.ucs.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	 <20100823080543.319143e3@nehalam>
	 <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	 <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	 <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
	 <1282688441.22839.34.camel@localhost> <20100824153920.63360072@s6510>
	 <alpine.WNT.2.00.1008251408520.632@cluij.ucs.ualberta.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 13:57:07 +0200
Message-ID: <1282823827.2476.663.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 août 2010 à 05:40 -0600, Marc Aurele La France a écrit :

> Steady now.  There's no need to YELL nor be arrogant.  You and I both know 
> there's a place for NFS over UDP.  That's not changing any time soon.  While 
> I'm aware of the issue you brought up, it is separate from the one at hand in 
> this discussion.
> 
> I do want to thank you, however, for reminding me of TCP.  It's something 
> 20/20 hindsight says I should have checked out before starting this thread. 
> Logistically, it'll be a few days before I can do so though.  If that allows 
> me to increase the MTU all the way up to 65520, then this UDP thing will 
> likely remain unresolved.
> 

Unfortunately, your infiniband device lacks NETIF_F_SG support.

MTU a bit larger than PAGE_SIZE-overhead will need high order
allocations ?



