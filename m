Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0LHMvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:51:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0LHMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:51:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Wed, 8 Dec 2010 13:51:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <AANLkTimCKK9NAiXD4wsCkJt8bsy_exYEBWdb1+M6+NOE@mail.gmail.com> <AANLkTi=B4wT5SbN2qyyO5RZd7qMnkZXHpB6d=RTQeRtX@mail.gmail.com>
In-Reply-To: <AANLkTi=B4wT5SbN2qyyO5RZd7qMnkZXHpB6d=RTQeRtX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012081351.43752.arnd@arndb.de>
X-Provags-ID: V02:K0:PgXdLfkMw0ZM7TKWdZOFhmg1pe9+rZHvyNNnRBrLiyK
 AA2zJH9ZVsaPA6fsKNzGaOJm84N2qYA31pJSSvU3S8Xldb8Xi9
 8ZwuRHrlZr1IlsLHQ8Pz6H+3qEPGPds4t0eqZaH5aXjCLE+1N/
 5GnJXUD+6zEMbAyN6Y//WbhpLrXlvc2/iO30+j1wlRjSJ2ZS/o
 BKRFvkHX7r8y2wFcMqvaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 December 2010, Par-Gunnar Hjalmdahl wrote:
> > Marcel did previously suggest a bus-driver sort of a structure, where
> > the transport are sort of adapter drivers, the data interpretation
> > logic like splitting HCI-events, FM CH-8 packets all fall into the
> > algos drivers and the actual Bluetooth driver or GPS or FM-V4L2
> > drivers falling into the client/protocol drivers....
> 
> What the cg2900 driver has now turned into is almost like the
> cg2900_core acting as a bus, identifying which chip is connected and
> choosing correct chip driver from this. This cg2900_core module should
> not contain any vendor specific code. When identified, the chip driver
> then uses MFD to setup channels according to the functionality it
> supports (one MFD device per H4 channel). It's hard to explain
> everything of the new architecture here. I would like you to check the
> new patch set I'm trying hard to create at the moment. I will try to
> get it out on Friday, but it's hard to promise anything (there is a
> lot of work to do with it). There you could then see if it is
> something you could consider useful.

It sounds really good, I'm looking forward to your new patch set!
If it's generic enough to replace the ti-st code, that would be a
clear sign that you are on the right track ;-)

I'm not asking to fix their code yourself, but it might be good to
look at it and see if it would work.

	Arnd
