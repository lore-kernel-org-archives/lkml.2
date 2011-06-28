Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1F1RJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:09:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab1F1RHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:07:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: [PATCH 2/7] serial/8250: move alchemy I/O handler to platform code
Date: Tue, 28 Jun 2011 19:07:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <BANLkTin9=5Yp6W8S6hSuUZ8w08eUhRxxQw@mail.gmail.com> <BANLkTimnH81zys5Ab4XpsyuNXK2B+MqQrw@mail.gmail.com>
In-Reply-To: <BANLkTimnH81zys5Ab4XpsyuNXK2B+MqQrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281907.24124.arnd@arndb.de>
X-Provags-ID: V02:K0:DM9Y7Hl3o3NW2H7xVzZhUJky4F7wntFa9/kCAkPH0dd
 dHdk1TDBUHeA8o/jTozFv9Nlqo//adSU8M6XdPx3BRW1KhKbus
 uZ8bhp2pGbiz/1cRYFn3N+hQY8uwft9L+VtF1J2HZ1ohxDWx7V
 fx53z6/tRo/Tk5VIk3hNFplGZsrSrZRHpJdmCBsTzlE/ZA2XNL
 7jwJHzKWAHRrc7ZxHS5qQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Manuel Lauss wrote:
> Okay, found it.  the Alchemy headers have definitions for UART_RX/TX/... with
> different values; they can be deleted safely since nothing depends on them.
> Here's an updated and tested patch.  I took the liberty to rename the functions
> a bit while at it.

Cool, thanks so much for tracking that down!

Please send me (in private) the Signed-off-by that you want me to add to the
patch, apparently you missed that.

I'll put your version in the series then.

	Arnd
