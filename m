Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0H2VwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:52:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51567 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0H2VwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gD2MP0EvJ+7SqPDOMAZmhv3E41I1S072P3ZThqtOXsiU8wgmOJgh3/MZuvlOdZGIeb
         pL9a2fMGS9O5+dukUDaYNm0DAi/Lv45RUjj8J3NRxSU1yRu/33IgRUZ/1KWigfvZElgY
         nVZgDnB9Peum8fjfgFKIrejwYyKbKwKVtRbHY=
MIME-Version: 1.0
In-Reply-To: <1283115995-4734-5-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <1283115995-4734-5-git-send-email-arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 29 Aug 2010 17:51:55 -0400
Message-ID: <AANLkTinE6E47=NbdWo28i6Z6i-6QqHUmF1+Tr7u_v8o3@mail.gmail.com>
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7TLqO70023838

On Sun, Aug 29, 2010 at 17:06, Arnd Bergmann wrote:
> Random obsolete tty drivers are mixed with random
> other stuff in drivers/char, this moves all the
> tty drivers into one place.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Â MAINTAINERS Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  22 +-
> Â drivers/char/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â 287 +------------------
> Â drivers/char/Makefile Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  28 +--
> Â drivers/char/pcmcia/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  22 --
> Â drivers/char/pcmcia/Makefile Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 3 -
> Â drivers/tty/Makefile Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 1 +
> Â drivers/tty/hw/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â 308 ++++++++++++++++++++
> Â drivers/tty/hw/Makefile Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  27 ++
> Â drivers/{char => tty/hw}/amiserial.c Â  Â  Â  Â  Â  Â  Â  | Â  Â 0

does it need to be in tty/hw/ ?  seems like there's so little in tty/
to not bother with a further hw/ ...
-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
