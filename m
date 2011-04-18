Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1DROT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:19:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DROTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:19:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Mon, 18 Apr 2011 16:19:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <201104171938.12834.arnd@arndb.de> <BANLkTim6iCAsViJQS4XrY-XObs8pp-BiQQ@mail.gmail.com>
In-Reply-To: <BANLkTim6iCAsViJQS4XrY-XObs8pp-BiQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104181619.35115.arnd@arndb.de>
X-Provags-ID: V02:K0:rEizRwWnsAqV7F2X1+rT81/t8DI76faRNjL0X1P/RCl
 5HDdEO5cWDcT45PD8Xt2CytRLAb28aX9AckZePedtGlDJazuAX
 u7PQNcz69tC6Ab5XI2LYou0z7lBaOa0Wanmu3d+i8xsHca4Zo1
 lKZoqg6B/JUGUcoxSS0CN2OCkaknFAu5/LoB1yu54YgbRPCual
 dtwEpy0seDEbKrOP1zTVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Rafał Miłecki wrote:
> W dniu 17 kwietnia 2011 19:38 użytkownik Arnd Bergmann <arnd@arndb.de> napisał:
>
> > In general, the bus_type directly relates to how a device gets probed.
> > If broadcom uses the same basic register layout as regular AMBA devices,
> > it should use the amba bus type.
> 
> From Broadcom side we *could* use some registers that are AMBA
> specific, they are present... but there is totally no point in doing
> that. Everything we use is Broadcom specific.
> 
> 
> > I think it would be fine to extend the AMBA bus slightly if there are
> > just minor differences.
> 
> As I said, Broadcom specific driver use nothing from AMBA common
> things. Plus we implement routines that are Broadcom specific and no
> other platform will use them.

You mean the hardware has two sets of registers containing the same
information, one of them the standard registers, and one with broadcom
specific ones?

Why don't you just use the standard ones then?

	Arnd
