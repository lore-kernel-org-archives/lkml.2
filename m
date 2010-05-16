Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0EPUi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 16:38:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:57344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0EPUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 16:38:56 -0400
Date: Sun, 16 May 2010 13:41:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Biereigel <security@biereigel-wb.de>
Cc: Donald Allen <donaldcallen@gmail.com>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: tickless scheduling
Message-ID: <20100516134151.4de917f5@infradead.org>
In-Reply-To: <4BF019CF.1030309@biereigel-wb.de>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	<AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	<AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	<1273540344.3843.101.camel@localhost.localdomain>
	<AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	<AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	<1273697523.2856.3.camel@localhost.localdomain>
	<AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	<4BF019CF.1030309@biereigel-wb.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010 18:14:07 +0200
Stefan Biereigel <security@biereigel-wb.de> wrote:
> Hello everyone,
> 
> I hope I can add something here, because I am experiencing the exact 
> same Problem as Don describes. I'm running a PackardBell EasyNote
> MB89 featuring a Core 2 Duo, 4 GB of RAM, Intel Chipset (Santa Rosa),
> SATA HDD. My Machine even hangs at boot, absolutely doing nothing
> until i wiggle the touchpad. This is definately reproduceable, but I
> think it doesn't occur that often in X-Window-System, if X is off I
> can just wait a couple of seconds and there I go.

this has nothing to do with tickless or not... you're losing interrupts.

if you're not tickless, there's just so many regular interrupts
happening that you don't notice that other interrupts are lost.


try disabling MSI (iirc pci=nomsi) to see if that helps..
