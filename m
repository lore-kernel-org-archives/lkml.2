Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0IMMmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:42:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IMMmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=n56utD5eUQW5KVyNDZMWxsKbLRGbD2f8znGe7FX+z2NTFRWjoCEVpj0w/2kyA1ae9d
         HLGlAFnaVx1HxKO87Um1i1eM41ptePWDMGydMw0KEOlKWzubtjDuE8sg+W4xFZGpWj6C
         +hPbY+hodSApzsUS8zmnhkOzB0D6YJ+CVZWXA=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Maxim Osipov <maxim.osipov@gmail.com>
Subject: Re: [PATCH v2] AT91: Add flexibity board support
Date: Mon, 13 Sep 2010 14:42:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <4C8DFA84.4040501@gmail.com> <201009131256.36523.marek.vasut@gmail.com> <AANLkTikotyfyvJ76-kemy_NPGEJifEF8PcuWuiomuc_2@mail.gmail.com>
In-Reply-To: <AANLkTikotyfyvJ76-kemy_NPGEJifEF8PcuWuiomuc_2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009131442.26618.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 13. září 2010 13:02:24 Maxim Osipov napsal(a):
> Hi!
> 
> On Mon, Sep 13, 2010 at 2:56 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > Dne Po 13. září 2010 12:18:44 Maxim Osipov napsal(a):
> > 
> > btw. don't you want to modularize this code a bit ? check how
> > mach-pxa/z2.c or mach-pxa/vpac270.c is done for example.
> 
> No, all functionality is needed in the product, so I do not think
> modularization is necessary.
> 
> Kind regards,
> Maxim

Ok, please fix the include then
