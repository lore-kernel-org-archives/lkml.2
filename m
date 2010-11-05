Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0KECQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:16:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0KECQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:16:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [00/01] TTY: create drivers/tty and move the tty core files there
Date: Fri, 5 Nov 2010 03:16:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20101104222906.GA3390@kroah.com> <20101104223001.GB3390@kroah.com>
In-Reply-To: <20101104223001.GB3390@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011050316.53455.arnd@arndb.de>
X-Provags-ID: V02:K0:gcpeI2IDesKwJKhqe+YjT8FzoMYaD86G7LuXyirS9Ru
 7hQGJP8MKRy+iUiDlLyl3saeqGIxH+xRTo8ExJJjgdDmIK9tnI
 A1inn4ahP1JkFFsO+E1w4QBHaAEbMPk8NFcMe4DuBiZ1GIh3t/
 DCpLme/JtUDp0cFboNAg3kLHEF0tiwyadUHspApUT7thzRJld3
 PHHnT8Dl9z8qVMbVElb/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> The tty code should be in its own subdirectory and not in the char
> driver with all of the cruft that is currently there.
> 
> Based on work done by Arnd Bergmann <arnd@arndb.de>
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
