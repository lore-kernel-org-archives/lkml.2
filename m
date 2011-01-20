Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1ATS1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:27:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62446 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1ATS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:27:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 2/3] tty: move drivers/serial/ to drivers/tty/serial/
Date: Thu, 20 Jan 2011 19:27:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
References: <20110120174910.GA30124@kroah.com> <1295546625-30681-2-git-send-email-gregkh@suse.de>
In-Reply-To: <1295546625-30681-2-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201927.48859.arnd@arndb.de>
X-Provags-ID: V02:K0:ReMpoGZlC0zPIBF57Bjnck2I8A4+t7lXTOZoTf+dVKG
 xLPy9lUlnMzHnZMEo60rWOEiZlW6umxkoS/y/L+QGD4m0NQXee
 OJotYRNy3lNe8LplhJEYVqS+mxJUQ0k2oxKg4m208lA0Qh3aF1
 98YpBRvMcvrutMlFoqE2N4a+8dpGkCy9qi9iH0M5sqm5BK7+6l
 jSEv91R2H21vuw6B4Qt2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 January 2011 19:03:44 Greg Kroah-Hartman wrote:
> The serial drivers are really just tty drivers, so move them to
> drivers/tty/ to make things a bit neater overall.
> 
> This is part of the tty/serial driver movement proceedure as proposed by
> Arnd Bergmann and approved by everyone involved a number of months ago.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>
> Cc: Michael H. Warfield <mhw@wittsend.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
