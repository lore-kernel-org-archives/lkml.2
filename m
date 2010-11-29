Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0K2PEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:04:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0K2PEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:04:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Subject: Re: [RESEND][BUG][PATCH]-rc: USB: yurex: add .llseek fop to file_operations
Date: Mon, 29 Nov 2010 16:04:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <4CEE8A99.5020906@gmail.com> <201011261622.29100.arnd@arndb.de> <AANLkTikddbZN2d+WWwJ_k7ZLpM5SS9H+2OLBZ1CgoZrB@mail.gmail.com>
In-Reply-To: <AANLkTikddbZN2d+WWwJ_k7ZLpM5SS9H+2OLBZ1CgoZrB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291604.12026.arnd@arndb.de>
X-Provags-ID: V02:K0:B6kTIE+RvzLWv+fowQHDXBNUatp5iloKKQ2+FYpJpLR
 v9k+87CV3M/4Wup1Zz36JRdgPDEAq93a4VCpkm6XnnVa5u9caH
 v4R4vbpUEWzkxpLFGdYzOBf/zxdnHdmO/zWSZNDk6zx/tZNPzL
 4PQZVxhJfWtjvA7+b3RiNQxClqJB+B0WyLQi4k0DF+wXejmDy3
 er1fxOhWj61g6kS7qnPng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 November 2010, Tomoki Sekiyama wrote:
> 2010/11/27 Arnd Bergmann <arnd@arndb.de>:
>
> > As far as I can tell, you don't really want to seek this file
> > anyway, so the default behaviour of disallowing llseek would actually
> > make more sense.
> 
> I need seek because the device notifies the update of the sensor's value
> by fasync, then the user can rewind(seek to 0) and re-read the file.

Yes, that makes sense.

Acked-by: Arnd Bergmann <arnd@arndb.de>
