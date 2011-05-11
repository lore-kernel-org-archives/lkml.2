Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1EKQ5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:57:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65322 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab1EKQ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bBUlM1hYgpLnL/i1+wrHJAwGou9A4yFGBd3hIIMpRLFGBkzJRc3ZMefQcd2X8416FM
         NAHwd5SR73U9Gld7NpBjNTSEyeMPZmpU7pIwgfxePD3SzxKvqQUGbBxMqQCRLc1woE5o
         K9zHX26Rd7ZGjHAHKCMCkb0dGm+bRib3SGVaM=
MIME-Version: 1.0
In-Reply-To: <20110510234526.GC18929@game.jcrosoft.org>
References: <4DC53134.8070706@gmail.com>
	<20110510234526.GC18929@game.jcrosoft.org>
Date: Wed, 11 May 2011 09:44:52 +0200
Message-ID: <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
From: Andrew Victor <avictor.za@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Maxim Osipov <maxim.osipov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

>> This patch enables external RTC support on AT91 Flexibity board.

Acked-by: Andrew Victor <linux@maxim.org.za>

Maxim: You can submit it to Russell's patch system.


> looks fine just one comment please add your board to the new at91sam9260_defconfig

That file does not exist in any mainline kernel.


Regards,
  Andrew Victor
