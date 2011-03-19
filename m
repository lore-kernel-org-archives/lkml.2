Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1CSPaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:30:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47711 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab1CSPad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:30:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: No networking since git3
Date: Sat, 19 Mar 2011 16:31:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Anca Emanuel <anca.emanuel@gmail.com>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
References: <4D84A46B.1000407@example.com> <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com> <1300547930.2831.27.camel@edumazet-laptop>
In-Reply-To: <1300547930.2831.27.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103191631.07952.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:

> Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
> (r8169: support control of advertising.)
> 
> Reverting it brings back NIC for me

Odd. It worked for me. Are you testing on a gigabit switch? Could you send
me dmesg? Does it work if you use ethtool to advertise a lower speed?

	Regards
		Oliver
