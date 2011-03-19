Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1CSPdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:33:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60537 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1CSPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vayfQEg1CKT9jyQLXZqq61Ji8EnWY2WUHORucIUaQE2Ky1jjTYN8E77AfTLYjO6czI
         m+NowpvScyvlEexVqVweWW28zCgOlsLNs7fftJZWN/L6tsl+NaJXA7BjUd9Sx7+13ewI
         Aedk9LHUtixtyEOiCBJ3HX0imzvBnt29eIE+o=
Subject: Re: No networking since git3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <201103191631.07952.oliver@neukum.org>
References: <4D84A46B.1000407@example.com>
	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	 <1300547930.2831.27.camel@edumazet-laptop>
	 <201103191631.07952.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 16:33:41 +0100
Message-ID: <1300548821.2831.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
> Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
> 
> > Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
> > (r8169: support control of advertising.)
> > 
> > Reverting it brings back NIC for me
> 
> Odd. It worked for me. Are you testing on a gigabit switch? Could you send
> me dmesg? Does it work if you use ethtool to advertise a lower speed?
> 
> 	Regards
> 		Oliver

I found the bug, I am sending a patch in two minutes.


