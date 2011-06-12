Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1FLWAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 18:00:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1FLWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 18:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=toUdPOX9PCcHWlFR52Fx2pu1r7nG89uM0ZyaWauIn10c3vuN+o92Tds5EGIKfB9UiW
         U3nc/25fV7mpakUDE4NXe1KL1ZPhA+o8iEqipx7ldN6yjD/s+3N4VFaXcpcix1zYVGPS
         ScuzsLS9G8NC19BFWTadu2kC4KFrjvNylirQU=
Subject: Re: [Bug #33842] NULL pointer dereference in ip_fragment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Tomas Carnecky <tom@dbservice.com>, David Miller <davem@davemloft.net>
In-Reply-To: <kTLfM29CaqB.A.K5F.f1S9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
	 <kTLfM29CaqB.A.K5F.f1S9NB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Jun 2011 23:59:52 +0200
Message-ID: <1307915992.2872.170.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 12 juin 2011 à 23:12 +0200, Rafael J. Wysocki a écrit :
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33842
> Subject		: NULL pointer dereference in ip_fragment
> Submitter	: Tomas Carnecky <tom@dbservice.com>
> Date		: 2011-04-23 07:51 (51 days old)
> 
> 

This is probably fixed in current linux-2.6 tree, and 2.6.39.1 as well


If not, maybe commit 64f3b9e203b (ip_expire() must revalidate route)
needs to be included in 2.6.39.X

(I believe Greg took it for 2.6.38, but cant find it in 2.6.39 ?)



