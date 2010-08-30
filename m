Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0H3LzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:55:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0H3LzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NF/RP7Mhx/K6SuEVOmKiSk+ZxGCjZ85PjUwL9NzoyM6Trnlxx3B6r9sBJldiMIvPeq
         7L/9se/Y/T2drggbYzHClLP0kq1ONrnQXWuB5dRoCcVxLjeBED3btlJaEP8gfkBZBKNr
         1/UY/dNDWsDDEwNqRBB9uPyBxhEb1LeHYmZWc=
Message-ID: <4C7B9C1D.9030207@suse.cz>
Date: Mon, 30 Aug 2010 13:55:09 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100830001855.1071b6fc@lxorguk.ukuu.org.uk> <201008301337.27672.arnd@arndb.de>
In-Reply-To: <201008301337.27672.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 01:37 PM, Arnd Bergmann wrote:
> These are the drivers I was planning to move:
> +obj-$(CONFIG_CYCLADES)         += cyclades.o

There are some users still with CYY cards. No CYZ card users known to me.

> +obj-$(CONFIG_STALLION)         += stallion.o
> +obj-$(CONFIG_ISTALLION)        += istallion.o
...
> +obj-$(CONFIG_DIGIEPCA)         += epca/
> +obj-$(CONFIG_SPECIALIX)        += specialix.o

These 4 may go probably. I remember Alan suggested epca to be removed
few years ago.

> +obj-$(CONFIG_MOXA_INTELLIO)    += moxa.o

Maybe few users left.

> +obj-$(CONFIG_MOXA_SMARTIO)     += mxser.o

Still in use. (And supports relatively new devices; not the PCI-e ones
though.)

> +obj-$(CONFIG_COMPUTONE)        += ip2/
> +obj-$(CONFIG_RISCOM8)          += riscom8.o
> +obj-$(CONFIG_ISI)              += isicom.o

Unused? isicom is broken last I heard.

thanks,
-- 
js
suse labs
