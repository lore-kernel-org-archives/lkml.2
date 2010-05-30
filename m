Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0E3UzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:55:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0E3UzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bw7RMZYN9gCjF3NUOh4l4viAyih4mIMBUii8E9+WXZ0du6d8UJ8IWptBy8ogl6k8vX
         dhIKIlWJXiGiePg4DDbfDvDx/D/L40GiOLR67fiXRWAt7mSPhBtNiZiEWlTqiKRQFDnP
         rFAPEffFeItyZ+vKSUXGjQ8W8uhJvdMl5naZk=
Subject: Re: Subject: [PATCH] net/ipv6: Use GFP_ATOMIC when a lock is held
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005302248500.19253@ask.diku.dk>
References: <Pine.LNX.4.64.1005302147310.19253@ask.diku.dk>
	 <1275250288.2472.21.camel@edumazet-laptop>
	 <Pine.LNX.4.64.1005302248500.19253@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 22:55:12 +0200
Message-ID: <1275252912.2472.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 30 mai 2010 à 22:50 +0200, Julia Lawall a écrit :

> I think the proposed patch does not work, because the for loop overwrites 
> p.  That use of p looks like it is completely local to the for loop, so 
> perhaps a new variable p1 could be added to be used there?

Please do so.

I just wanted to tell you changing GFP_KERNEL to GFP_ATOMIC is not an
appropriate way to solve this kind of problems. My patch was to get an
idea, not a full and tested patch :)




