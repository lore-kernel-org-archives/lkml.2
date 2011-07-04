Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1GDUht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:37:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GDUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:37:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Date: Mon, 4 Jul 2011 22:37:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <201107042127.31649.arnd@arndb.de> <20110704205336.09547e1f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110704205336.09547e1f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107042237.05295.arnd@arndb.de>
X-Provags-ID: V02:K0:PJuJ/jWCEmROmhWCqTG2TFRyioJauIIwfDI57cKlNxP
 twxQ96tqJDb9bLhaH+ehT5BnEleY06YFqbdX40XET0hYwH/NLV
 eA0rySSSvbO78wPOaokLZ2KpgKIhcaKeIBKKULRRS5SKhwYDjm
 C5X9YEH2nREQEC57SaR08qcgY7KKwHs25MqIINpSXLeir6BME5
 hRZVOwVNpZ3v+CH9GmM8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011 21:53:36 Alan Cox wrote:
> > Ok, makes sense. If I split this out to the ISA driver, I would
> > probably also disallow changing io_type, as ISA 8250 ports are
> > all based on PIO mode.
> 
> Alas not, they also come in MMIO form now and then, not often but just
> enough to be annoyingly unignorable. However the ISA driver can handle
> that 'in-house' and I've never seen anything but PIO or simple MMIO.

Ok.

How are people using those ISA cards today? The version of setserial
that I found is not able to set MMIO mode on those. I suppose you
are not talking about isapnp cards, right? Those should not need to
be handled through the ISA driver at all.

	Arnd
