Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1CSQmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:42:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47832 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1CSQmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=frn42bJs+5rWRNDgMiD1eX1rI7rpH/3wIZNoPEVDeY+zp7Q+Ah7Aa6+nC643Qf+L77
         DLhjGDniJf/Q67zqAtLHBU4riPN0BKjg61KNSD3uoBCq+SPUvAg/am5S7osUWQHKU+L/
         bkJEecNKfpgOz0ErvOBX4gFHWwTEFEejW98cc=
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: piotr@hosowicz.com, Oliver Neukum <oliver@neukum.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTim9m2A6MXBrx2QHLYNTph9mW9+BUyQpwL5QpjtB@mail.gmail.com>
References: <4D84A46B.1000407@example.com>
	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	 <1300547930.2831.27.camel@edumazet-laptop>
	 <201103191631.07952.oliver@neukum.org>
	 <1300548821.2831.28.camel@edumazet-laptop>
	 <1300549151.2831.32.camel@edumazet-laptop> <4D84D098.1050802@example.com>
	 <1300550653.2831.34.camel@edumazet-laptop> <4D84D956.8090407@example.com>
	 <AANLkTim9m2A6MXBrx2QHLYNTph9mW9+BUyQpwL5QpjtB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 17:41:56 +0100
Message-ID: <1300552916.2831.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 18:38 +0200, Anca Emanuel a écrit :

> Next: Test Eric's patch, and send and email with Tested-by tag.

Well, my patch was actually tested on one of my machines ;)



