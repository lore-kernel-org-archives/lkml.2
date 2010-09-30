Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0I3GeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:34:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0I3GeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oNDDbE5rWgp3Fbf2pbE2cRbsLvqf42/wEgIRPINPtqTqEfJ25L0Qkd4KoTKn3mhYl5
         nUPMhaGj3DLMEQfu0LM19AXqKZYp2SaU0A2XlteTqUZzn3KMz/dbEDja2OfKQGnCMSWP
         QBWocR9c6OJ2cYpBTxHrT9wXBr50rke9oP8l0=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100930062419.GD86786@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
	 <1285796721.5211.156.camel@edumazet-laptop>
	 <20100930062419.GD86786@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 08:33:52 +0200
Message-ID: <1285828432.5211.812.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 10:24 +0400, Alexey Vlasov a écrit :
> Here I found some dude with the same problem:
> http://lkml.org/lkml/2010/7/9/340
> 

In your opinion its the same problem.

But the description you gave is completely different.

You have time skew only when activating a particular iptables rule.

No ?


