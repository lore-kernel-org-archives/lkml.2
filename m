Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0IUQb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:31:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55061 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0IUQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TJaKM6pQK8HdWRwAeRNCCqSm+6VMLTidC9mSQenfqvgK4fTf81tclEj61yT1eQTK+A
         CvFNQxt/qQAZjDhknYlVy3JrzcLuj/5AEFx1USpQncyF/KRFLZcCdgLWKe5SVGnmhA7F
         MieZZS7fPAHUEXCOlfkA8V6f8oo2MMEe1zvXc=
Subject: Re: [PATCH v3] ip: fix truesize mismatch in ip fragmentation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jarek Poplawski <jarkao2@gmail.com>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100921162657.GA22183@khazad-dum.debian.net>
References: <20100920174443.GA5515@elliptictech.com>
	 <1285006844.2323.17.camel@edumazet-laptop>
	 <20100920195256.GA14330@elliptictech.com>
	 <1285013853.2323.148.camel@edumazet-laptop>
	 <1285018272.2323.243.camel@edumazet-laptop>
	 <20100921140501.GA21572@elliptictech.com>
	 <1285078613.2617.503.camel@edumazet-laptop>
	 <1285084705.2617.636.camel@edumazet-laptop>
	 <20100921162657.GA22183@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 18:31:19 +0200
Message-ID: <1285086679.2617.672.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 13:26 -0300, Henrique de Moraes Holschuh a
écrit :
> Should this be a candidate for -stable?
> 

Yes, of course, but David wants to handle stable submissions himself.

I am not sure we want to bug stable team with dozens of mails while
polishing patches ?

Thanks


