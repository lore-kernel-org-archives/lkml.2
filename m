Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1CSQEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:04:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45345 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab1CSQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cf1t+bGLqm3N5ddY/oMr2yiuS98/i88W4J9Q1w/P94f50MZkOgZFxMjbuEtmLG3+ZB
         SqTUV/VDRcZzw0HqMYScLVmZWgYUWAGIRx/X2+xr/6EyjV5heqLaR8MIDHKER2Bfhm+A
         NRz/4n/Z3FZdtTJkR0rI78m8f8ivCFy8a2cUA=
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: piotr@hosowicz.com
Cc: Oliver Neukum <oliver@neukum.org>, Anca Emanuel <anca.emanuel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <4D84D098.1050802@example.com>
References: <4D84A46B.1000407@example.com>
	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	 <1300547930.2831.27.camel@edumazet-laptop>
	 <201103191631.07952.oliver@neukum.org>
	 <1300548821.2831.28.camel@edumazet-laptop>
	 <1300549151.2831.32.camel@edumazet-laptop>  <4D84D098.1050802@example.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 17:04:13 +0100
Message-ID: <1300550653.2831.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 16:49 +0100, Piotr Hosowicz a écrit :

> I do not understand. I reverted the commit you mentioned and am building 
> now. Will it suffice?
> 

Either you

1) Revert the commit

OR

2) apply my patch


;)


