Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1ELPdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:33:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43834 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1ELPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vruZLeOtOLJ80n9HeItnLGDRZIY7fK3m2ES7KJzR6GKapobkUfB+UkCtZhqFqGxOLV
         cwhv1ytOw7NGkHGi4qgdsUC2Laj7AKjbz8sDfK0fkFJ8WtK39lmGAlJBb2ogjNzWsD2E
         sPCd5vRoGlnG9B+9dY0Kgg9vYgf1Clbs39LN4=
Subject: Re: [PATCH net-next] net:set valid name before calling ndo_init()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Weiping =?UTF-8?Q?Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Tom Herbert <therbert@google.com>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1305207541-13311-1-git-send-email-panweiping3@gmail.com>
References: <1305207541-13311-1-git-send-email-panweiping3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 17:33:02 +0200
Message-ID: <1305214382.3795.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 mai 2011 à 21:39 +0800, Weiping Pan(潘卫平) a écrit :
> From: Pan Weiping <panweiping3@gmail.com>
> 
> A bug of bonding was invloved by e815d19ffe02bdfda1260949ef2b1806171,
> see example 1 and 2.
> 

I cant find e815d19ffe02bdfda1260949ef2b1806171 in net-next-2.6

but I do find 1c5cae815d19ffe02bdfda1260949ef2b1806171

Please always use following when referring to a commit :

... in commit 1c5cae815d19 (net: call dev_alloc_name from
register_netdevice) ...

- just limit to _first_ 12 chars, no need to have full length
- give the commit title





