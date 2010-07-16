Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918Ab0GPPmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:42:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44939 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965907Ab0GPPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aBTxLAiY6QAW/00qLnrUdfAhZ0umTePnBw0FhKNlSlWJ9fPvykzQWPu2LBULnS84co
         a9TZRdGbWhahEIvnnna+Hg0fcjgm+K/oE5/lW2ffczUmhAbMKOBAJc+Wc3fpxgR103Ad
         YZqrvX/9q9vVYO6MZjgjYyNiWZjWaBh9vM7ys=
MIME-Version: 1.0
In-Reply-To: <AANLkTimwi7IuKZySIkDjlgBi7NDkIaW79CHNbhliJ2UY@mail.gmail.com>
References: <1278921056.22437.1.camel@eight.analog.com> <AANLkTimwi7IuKZySIkDjlgBi7NDkIaW79CHNbhliJ2UY@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 16 Jul 2010 11:41:54 -0400
Message-ID: <AANLkTimFXbOs7QzKd2sK-m1xh1p3Mg2pl_T2_xwAE7nS@mail.gmail.com>
Subject: Re: [PATCH v2] MMC:mmc_spi: Recover from CRC error for SD read/write 
	operation over SPI.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-mmc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 06:51, Sonic Zhang wrote:
> Any comments?

might want to CC akpm so he'll pick this up in case the mmc guys miss it
-mike
