Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0H3VE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:04:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0H3VEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:04:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Mon, 30 Aug 2010 23:04:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008301415.56934.arnd@arndb.de> <20100830140054.294a15f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830140054.294a15f1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008302304.45157.arnd@arndb.de>
X-Provags-ID: V02:K0:5+cCVkxI2/G2+G5a5kYnK8B6fnPRmCtQBxxJ5WqNzlQ
 nlbY7Nm6JLA3ga8T7J1C/YRqRpfMjRIHCGvtdphUbETcFdkS0s
 YSXxY121J+B5wr9v0Sl9x6YQst5RtFzLJFbcLXWGjpB93BX1HD
 8l9b9EsWET3V4REHzQIky5MCGefAkLqUvYtSKth9Svwn/eknZ3
 hZNWCS3lNTy22V/6n+XFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010 15:00:54 Alan Cox wrote:
> > 
> > Are they all candidates for a conversion to serial_core then?
> > Or are they not sufficiently 8250-like?
> 
> Please don't convert stuff to serial_core - it's got some horrible
> problems with adapting to the new locking model, its buffering model
> pre-dates kfifo and all in all serial_core needs a rewrite not more users.

Ok. I was under the illusion that drivers/serial contained the good
stuff while drivers/char/ had all the bad serial drivers that nobody
cared to convert. Do I understand you correctly that there is actually
not a single serial driver that can serve as a good example for other
drivers then?

	Arnd
