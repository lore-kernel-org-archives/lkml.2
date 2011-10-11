Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1JKSl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:41:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1JKSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:41:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, claudio@evidence.eu.com,
        jesper.nilsson@axis.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] tty/serial: RS485 bindings for device tree
Date: Tue, 11 Oct 2011 20:41:04 +0200
Message-ID: <3289709.mzRgbAUyPT@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E947CA6.9010703@atmel.com>
References: <1318353208-24422-1-git-send-email-nicolas.ferre@atmel.com> <4E947CA6.9010703@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:f2FMVwcCOchHSEjnsX6FLhipEvYrdOechQxozO4JN6t
 3W6cUPusThu0M1LpMW0NFemH29b++sf2qqvwGLzhHZCPFxPkXo
 TZ9+AtERharSjufHiSB0fzxPKqPRTibxtaRrYG9fIUHuP8EMGJ
 G3hYya+sTbea4yz6KJ/qw/mEW9fJ062fRo9cXhOCwBlYRZzUVL
 Xc51oze6n6vxBmzFxydZAT/6A8Q+dUzymuOWJeTDKdaUak75qG
 FKVUUCzNbCzhYf4f0gGeo1kx3VMMOHbg9dwMHWRfSL/yB4jRRZ
 50NI+5hEmBcT1iAUVTnL7itGIuuAyIGiv4hrZwvPdeNFCZ5Ioj
 u3VMB/9+I0kvisUReZyA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 October 2011 19:28:06 Nicolas Ferre wrote:
> 
> > +Optional properties:
> > +- linux,rs485-enabled-at-boot-time: empty property telling to enable the rs485
> > +  feature at boot time. It can be disabled later with proper ioctl.
> 
> +- linux,rs485-rx-during-tx: empty property that enable the receiving of data
> +  even whilst sending data.


This does not sound too linux specific. If it's a hardware property, don't
use the 'linux,' prefix and just make it 'rs484-full-duplex' or such.

	Arnd
