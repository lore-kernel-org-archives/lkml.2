Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161211Ab2CSPU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:20:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35894 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab2CSPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:20:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F674616.8080103@gmail.com>
References: <4F576FD5.2050208@gmail.com>
	<CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com>
	<4F577D9B.7020402@gmail.com>
	<4F579A88.6030503@openwrt.org>
	<4F61F551.5010608@gmail.com>
	<4F639851.5080500@gmail.com>
	<4F674616.8080103@gmail.com>
Date: Mon, 19 Mar 2012 20:50:25 +0530
Message-ID: <CAD2nsn3xpkGenrK50YmE5D7Odg3sBEek5zKcLZF6MAm69p5RJg@mail.gmail.com>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024
 AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        Linux-netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

> seems I got this when waking up from suspend, was trying to connect with NM
> then all of a sudden Xorg shut off and this appeared on the screen(image
> links below I could not save dmesg only pic)
> http://flic.kr/p/bEhf2K
> http://flic.kr/p/bEhf2x
> http://flic.kr/p/bEhf2n
> http://flic.kr/p/bEhf26
>
> I see ath9k in the image, but am unsure if its related.
> kernel is: 3.3.0-rc7-next-20120316

this looks like some new issue  in ath9k, lets try to recreate it here

>
> Justin P. Mattock
>
>
>



-- 
thanks,
shafi
