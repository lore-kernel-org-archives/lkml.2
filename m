Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0JYT5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:57:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab0JYT5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MhG9G5liyksd/Ky1rFGioMr6lXVS/mxoiistNYolEFdd/jQ8CHArtMNjAUQp2fsdPx
         06w4Exj77QkyjHh4iGarTz1/KJ+Fj5etLd/LsBnW100OA8WV+Yfcp9h6F+FymPCWxH5I
         DoWeJx/ECYNzeivR/wFiQONuYpHVHnbYcz60g=
Subject: Re: [PATCH] net: b43legacy: fix compile error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnd Hannemann <arnd@arndnet.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
In-Reply-To: <4CC5C863.9070801@lwfinger.net>
References: <1288017690-31248-1-git-send-email-arnd@arndnet.de>
	 <4CC5A301.1080606@lwfinger.net> <1288021905.2826.142.camel@edumazet-laptop>
	 <4CC5C863.9070801@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 21:56:52 +0200
Message-ID: <1288036613.2451.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 25 octobre 2010 à 13:11 -0500, Larry Finger a écrit :

> I have no idea why that header was included - likely historical in the
> transformation from bcm43xx to b43legacy. For completeness, there are 2 more
> places to change:

Anyway, Arnd patch is fine by me, I didnt want to supply an alternate
patch.

I only was wondering why the include was in this driver...

