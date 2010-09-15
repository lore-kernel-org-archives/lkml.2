Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0IOPIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:08:48 -0400
Received: from gw1.transmode.se ([213.115.205.20]:45027 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0IOPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:08:48 -0400
In-Reply-To: <4C90CA4D.2020902@c-s.fr>
References: <4C90CA4D.2020902@c-s.fr>
Subject: Re: [PATCH] fixes probe issue and hangup in spi_mpc8xxx.c for data bigger
	than PAGE_SIZE
X-KeepSent: E529E700:F5762D7C-C125779F:0052EF12;
 type=4; name=$KeepSent
To: LEROY Christophe <christophe.leroy@c-s.fr>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        spi-devel-general@lists.sourceforge.net
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OFE529E700.F5762D7C-ONC125779F.0052EF12-C125779F.005327C5@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 15 Sep 2010 17:08:16 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.2 HF23|September 01, 2010) at
 2010-09-15 17:08:45
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>   This patch applies to 2.6.34.7. It also applies to 2.6.35.4 althought
> part of it is already included in 2.6.35.4
> It fixed a problem with spi_mpc8xxx.c when transmitting or receiving
> data bigger than PAGE_SIZE when doing a read only or write only operation
> It also fixed an issue with the init probe when fetching the information
> on parameter RAM from the DTB.

I think you need to break this up into 3 patches. It can't go into Linus
tree as is and it can't go into stable before it is in Linus tree.

    Jocke

