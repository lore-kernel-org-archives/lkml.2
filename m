Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1GBTpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:45:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1GBTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:45:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2 1/1] asm-generic: add MMU variants of io.h functions
Date: Sat, 2 Jul 2011 21:44:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        vapier@gentoo.org, liqin.chen@sunplusct.com, gxt@mprc.pku.edu.cn
References: <CAMjpGUeMqVzcAWKpAojZVbj9ywH+4HmW4Hx-8D1WQmTqPSNqQA@mail.gmail.com> <1309628168-3413-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1309628168-3413-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022144.38905.arnd@arndb.de>
X-Provags-ID: V02:K0:94Tsm0vheGP/Jz9ktlG2uteqZ1T3UeKSzotzGBaK3Xt
 yS6oDqNUQttX4uK9SbkxVdSTk6YKzWiVZ2kGV9P/st0zF2RfMl
 veAC/vZWFA+OwIHkz/xvjthYrEHUrcL9EacWNPk33fqAxl5Naz
 6xQRuH+OI0IObbzvziPfidePppwfZRLlZrlmFSUyrPP0+3DIp3
 +xoAhWJTkBgRvIrjIMfdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 19:36:08 Jonas Bonn wrote:
> 
> Some of the implementations, in particular the ioremap variants, in
> asm-generic/io.h are for systems without an MMU.  In order to be able to
> use the generic header file for systems with an MMU, this patch wraps
> these implementations in checks for CONFIG_MMU.
> 
> Tested on OpenRISC.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> Cc: vapier@gentoo.org
> Cc: liqin.chen@sunplusct.com
> Cc: gxt@mprc.pku.edu.cn

Acked-by: Arnd Bergmann <arnd@arndb.de>
