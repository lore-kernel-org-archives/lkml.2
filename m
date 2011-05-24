Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab1EXQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:20:39 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60084 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1EXQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JRdLGe9S//RKmM7thQVKqUEBHyWxbb4W2ejo4Z0B0P/XBUWU01gUnfXdmruLVkaBCd
         qF2LmNRdH30jiKjOcEGwgo6Alt2sN6bnQ0OeEYnbH88AUFVD3SdskKkneypGgBDJgymQ
         XO9xdIXnSxad6US8snx6zewB0TcwLwHY+KfGk=
Subject: Re: kernel BUG at net/ipv4/tcp_output.c:1006!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: TB <lkml@techboom.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4DDBD834.6080804@techboom.com>
References: <1305307633.3866.61.camel@edumazet-laptop>
	 <4DCD86C0.9030904@techboom.com>	<1305316058.3120.6.camel@edumazet-laptop>
	 <20110513.160138.1477780250019480052.davem@davemloft.net>
	 <4DD54E89.7050707@techboom.com> <1305825086.3028.84.camel@edumazet-laptop>
	 <4DDBD834.6080804@techboom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 18:20:33 +0200
Message-ID: <1306254033.3026.67.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 mai 2011 à 12:09 -0400, TB a écrit :

> That's all I'm expecting :)
> 
> However we've got 3 servers that hung with a blank screen and no network
> over the weekend and nothing unusual in the net console

Oh well, it could be anything ...



