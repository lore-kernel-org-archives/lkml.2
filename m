Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1CSPoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:44:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35373 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1CSPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aiPGOIirpWTF+ix6UBxqFaeirF5nFz6IVkQMf2eBgX/cFUHRay/gOVOPOBcU58H70W
         wu9nwmML2FSPp+kVf+OsTmrfvg5t8ilHfXXVhQETozku5NOHgyZohfL9KQr+IDanGomM
         Dz8U8op7nd3QTh40Y789CNNUL/KLEGCHQn/R4=
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <201103191641.41718.oliver@neukum.org>
References: <4D84A46B.1000407@example.com>
	 <1300548821.2831.28.camel@edumazet-laptop>
	 <1300549151.2831.32.camel@edumazet-laptop>
	 <201103191641.41718.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 16:44:02 +0100
Message-ID: <1300549442.2831.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 16:41 +0100, Oliver Neukum a écrit :

> Thank you. I feel like banging my head against something.
> 

Well, it happens, dont worry ;)


