Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1CSPlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:41:07 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:47505 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1CSPlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:41:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
Date: Sat, 19 Mar 2011 16:41:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Anca Emanuel <anca.emanuel@gmail.com>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
References: <4D84A46B.1000407@example.com> <1300548821.2831.28.camel@edumazet-laptop> <1300549151.2831.32.camel@edumazet-laptop>
In-Reply-To: <1300549151.2831.32.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103191641.41718.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 19. März 2011, 16:39:11 schrieben Sie:
> Le samedi 19 mars 2011 à 16:33 +0100, Eric Dumazet a écrit :
> > Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
> > > Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
> > > 
> > > > Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
> > > > (r8169: support control of advertising.)
> > > > 
> > > > Reverting it brings back NIC for me
> > > 
> > > Odd. It worked for me. Are you testing on a gigabit switch? Could you send
> > > me dmesg? Does it work if you use ethtool to advertise a lower speed?
> > > 
> > > 	Regards
> > > 		Oliver
> > 
> > I found the bug, I am sending a patch in two minutes.
> > 
> 
> Here it is
> 
> [PATCH] r8169: fix a bug in rtl8169_init_phy()
> 
> commit 54405cde7624 (r8169: support control of advertising.)
> introduced a bug in rtl8169_init_phy()

Thank you. I feel like banging my head against something.

	Regards
		Oliver
