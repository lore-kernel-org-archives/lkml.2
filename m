Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GAPJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:09:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55883 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1GAPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:09:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: AT91: Fix pull requset
Date: Fri, 1 Jul 2011 17:09:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org
References: <20110701065411.GD14408@game.jcrosoft.org>
In-Reply-To: <20110701065411.GD14408@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011709.40359.arnd@arndb.de>
X-Provags-ID: V02:K0:YEE4MsR1wh5dAeuUoc4P4m8Dpjvr1LwsOPRDIVVqLmE
 mVOt/5bZ5BgdFVqVcTxpzXbRzEQTHRXsWG7jgmKYiUg0PHR9JX
 ILhwG99Qh345UK06LpwLy/qT6dQcbHFppmpOKV2FmbyNKAkw80
 Ho4ebYb5cDilUbtaL8CiigHJ14/HI131WyyRhmqeP7XNCnUXUC
 uI9Ya2XzfdZkWo9dbtPzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 July 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> HI Linus, Russell, Arnd
> 
> 	I do not known who can take this pull request
> 
> 	But this is some fix for at91 for the 3.0

I can take and forward these next week, possibly together with other bug
fixes that come in for soc trees.

One comment though:

> Jean-Christophe PLAGNIOL-VILLARD (3):
>       at91: fix at91_set_serial_console: use platform device id
>       atmel_serial: fix internal port num

These two patches look like they should apply to older kernels as well:
The code you change has been in the kernel since 2006.

For every bug fix you commit, please check if it applies to older
kernels as well, and mark with 'Cc: stable@kernel.org' if so. Do you
want to update the changelog and send another pull request?

	Arnd
