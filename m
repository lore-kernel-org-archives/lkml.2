Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0LFOtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:49:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LFOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:49:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Mon, 6 Dec 2010 15:49:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <AANLkTikMAWikj9HQ76YVeHr7pMoFK6ME2=HHpuQ1kUxq@mail.gmail.com> <AANLkTi=V+89hmBP8iqz13xMhYVfnBkbiVnk=FY=OBE8T@mail.gmail.com>
In-Reply-To: <AANLkTi=V+89hmBP8iqz13xMhYVfnBkbiVnk=FY=OBE8T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061549.01534.arnd@arndb.de>
X-Provags-ID: V02:K0:LphxzjHkEDRqCh+VfuEYYLIzCCJEJWFeFu1vli5EYG1
 qTj/ReVUaUcuFShanhDGeZYrdBD6LXm8F01gOR518aU3KpuSi7
 oGueK7ZeWTn+jTQScAWme3nwWuxZ/YrD26VSoYfQ+Ax/MiFzpu
 n04z6GrEFKuFK5BHjzEiLbhBp7wUqw+hBeaNdh4j3iR4D54Hb0
 PEXMnH0fWbwUW5AuUATsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, Vitaly Wool wrote:
> > As a quick answer to your question: that would depend on the
> > difference between the different controllers, I guess. But CG2900
> > doesn't support the LL protocol so it is not an issue for that.
> 
> Right, but if you are only aiming cg2000, why would you create a
> framework for that?  I initially thought your solution was generic
> enough to handle other "many-in-one" Bluetooth chips but I'm
> completely unsure about that now.

As far as I understand, the point is that it's no longer a 'solution'
at the core, i.e. there is no replacement for hci_ldisc or any
of these, just modules for the additional h4 protocols that don't
have a linux implementation yet.

The patch set that was originally posted here had a new framework,
but after the comments from Alan and me, Par-Gunnar agreed to use
the existing framework instead and extend it in a useful way.
Please read all of the discussion we already had. You made a good
point here, but I fear you had both Par-Gunnar and me confused
because it was a point that already got resolved.

	Arnd
