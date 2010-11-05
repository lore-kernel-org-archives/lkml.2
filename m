Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0KECQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:16:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab0KECQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:16:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [02/02] TTY: create drivers/tty/vt and move the vt code there
Date: Fri, 5 Nov 2010 03:17:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20101104222906.GA3390@kroah.com> <20101104223001.GB3390@kroah.com> <20101104223100.GC3390@kroah.com>
In-Reply-To: <20101104223100.GC3390@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011050317.18360.arnd@arndb.de>
X-Provags-ID: V02:K0:riA3ghW2GK+Mfd20wcZWj8645tRNPLG4F4hCkfbMBUj
 +1QJHmXKohQIRyVYIbFdN2USxQ6cvT+vbZYWBu3OgEKD0g9sCO
 JfmwpFpn36rHYsVpJQF37lwhkexhfkzRSVeuEbNkbsUo67aypH
 XkPt6EWIo9fcmGGcuh9K7oesIEEIh/9vEQornlM2Pp1d9fmXWS
 nSwB7ipxtE0tmfLBcp+9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> The vt and other related code is moved into the drivers/tty/vt directory.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
