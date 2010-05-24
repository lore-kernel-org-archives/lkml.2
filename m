Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0EXKEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:04:31 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:60353 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab0EXKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:04:29 -0400
Message-ID: <4BFA4F08.5010700@euromail.se>
Date: Mon, 24 May 2010 12:03:52 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>	 <20100519023727.GA21030@barra.bne.redhat.com>	 <4BF3D59E.1070801@euromail.se>	 <20100520001323.GA28116@barra.bne.redhat.com>	 <4BF51188.3090608@euromail.se> <20100524045855.GC16369@barra> <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
In-Reply-To: <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGUVo-0000BX-7d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OGUVo-0000BX-7d 0df47004e3872e8d81f6d15819264818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
[...]
> This topic is outside of the _MT_ protocol discussion.
> 
> However, it is indeed an issue with all filtered input events, both
> for MT and regular ones.
> 
> I think we need to add an ioctl to enable user land driver/client to
> signal the kernel driver to send all events without filtering, just
> once. Hot-plugged devices and X driver starts after user has contacted
> with the device are two examples that the client would miss filtered
> events.
> 
> Dmitry, do you think it is a valid suggestion?
> 
> I've had this issue for ages (but never had time to work on it :(.

It would be easy to initialize a catch-up when opening the device for a new
client (evdev_open()).

Henrik

