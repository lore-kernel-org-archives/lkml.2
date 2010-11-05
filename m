Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0KECSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:18:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0KECR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:17:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [00/02] TTY: move the tty core to drivers/tty
Date: Fri, 5 Nov 2010 03:18:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20101104222906.GA3390@kroah.com>
In-Reply-To: <20101104222906.GA3390@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011050318.13420.arnd@arndb.de>
X-Provags-ID: V02:K0:UOq/wma0waVnbF90ekp4WzVm6opYHq+Ra7UrsMHs2hS
 Ksjm25p6Hn5mFWbzvQNecMn9lTuxRGHc2pr4bbgqcTlbv6XUWB
 QCWyp+cHg7WPWH2zE4yc5p7yQziuZoF+aQU7cELtBFgqOD0muP
 dehAMzbIKdcUrXJJzicvqRMKIqZaV7yExxWMT+zpYfG4nLkxRC
 Knu4PGU5dV9w0uUkOuftg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010, Greg KH wrote:
> Here's the latest version of the "move the tty files around" patch that
> I'd like to send to Linus now that -rc1 is out and things have settled
> down.  It only moves the tty core and the vt code out of drivers/char.
> I'll do the movement of the serial drivers and other things that were
> discussed later, for .38, but I wanted to get this move to him now as
> it's easiest to do so at this point in time.

Ok, that sounds like a good way to stage this.

Thanks,

	Arnd
