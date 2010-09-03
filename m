Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0ICPaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:30:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0ICPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:30:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 17:29:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100830184737.GA21339@suse.de> <201008302333.22447.arnd@arndb.de>
In-Reply-To: <201008302333.22447.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031729.58102.arnd@arndb.de>
X-Provags-ID: V02:K0:X2baRJ6hz+RQsRVnQLt3+9nLZgn6xECp+CpBMcMSRpp
 N7irKQC3q49e9Nc/vT89VTiuS6wzcy0PCc1cDg/LingB15SLPQ
 P0fUozLA8THbVczF2bHhCAU80a574+bK43YR4KeMEUKIEaHG5G
 r9rfgT69d86dN7/DT9b+EC7wFPsHS2KRnl6o7+vBsZddMhu90w
 jYolvXFVoSj67UyzTNC2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the updated list, I hope I captured all the comments correctly:
 
drivers/char/tty_*      -> tty/*
drivers/char/{vt stuff} -> tty/vt/

drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
drivers/serial/*        -> drivers/tty/serial/*
drivers/usb/serial      -> drivers/usb/serial

amiserial,nozomi,synclink,
rocket,ipwireless
cyclades,moxa,mxser,
isicom,bfin_jtag_comm   -> drivers/tty/

stallion,istallion,
epca,specialix,ip2,
riscom,serial167	-> drivers/staging/tty/*
 
generic_serial,vme_scc,
ser_a2232,sx,rio        -> drivers/staging/generic_serial/*

	Arnd
