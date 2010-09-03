Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0ICRmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:42:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0ICRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:42:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 19:42:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201009031729.58102.arnd@arndb.de> <20100903165522.GB26271@suse.de>
In-Reply-To: <20100903165522.GB26271@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031942.46289.arnd@arndb.de>
X-Provags-ID: V02:K0:iMsZfCb3PcRN+/yeHqbVQTLgXpyH5pLQF47Xz4/iN9v
 pVrWnqP3opvuRSmlMSYz5Q5ImiqB0B84U8WT18Lpwuxa0f6YDc
 qr11i3+DQVvEZIFcr/aTMAP+pDtXarEqd4Q125yYmpDUP//8UV
 GlO0qP99SLjbCZkyEb2mMX01Rs2s0f+UM+MlH+w/vvI57UNmmf
 V6PafGxJGgI9bkiK6JD1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 September 2010, Greg KH wrote:
> As this is just a lot of code movement, it probably makes more sense for
> me to do this myself, right?

Depends on whether you want a git tree or full patches for this.
I'd prefer not doing it myself, if you already offer to do it.

I guess the hardest part is splitting the Makefile and Kconfig
files appropriately. I've done that mostly for the first version,
so you should probably start from there and move it around some
more, splitting out the staging parts.

	Arnd


