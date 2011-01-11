Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1AKVaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:30:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1AKVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mqkkS9vm+wq6ABSE3e2pjyqsB0iiJc7r+aBPzyaGVY7DJmJg8NEjT9HhnWX/hymZPW
         QYVTQvHzzWNa4Oe6pckrh6DBTdhwevoEzAgCQkEwAuAHVfiw24Mww8bjlfE2jqNWDJeE
         /waeV5t5RdKW+EIpNKbErD6RScmtxHpXdZPDo=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, jj@chaosbits.net, daniel.baluta@gmail.com,
        jochen@jochen.org, hagen@jauu.net, torvalds@linux-foundation.org,
        pavel@ucw.cz
In-Reply-To: <1294780480.17388.2.camel@wall-e>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
	 <1294765273.2927.65.camel@edumazet-laptop>
	 <1294779020.16410.2.camel@wall-e>
	 <20110111.125254.133402589.davem@davemloft.net>
	 <1294780480.17388.2.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 22:30:27 +0100
Message-ID: <1294781427.3447.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 janvier 2011 à 22:14 +0100, Stefani Seibold a écrit :

> If nobody need it and no user in the near future out there, why should i
> implement this? That is dogmatic only!
> 

Sure !

Problem is linux kernel code is not your own project.

Some community rules must be respected.

You call this dogmatic, you are right, since this makes your life less
easy.

However, for hundred of people working to maintain/improve linux kernel
code, especially in network stacks, this ends in less stress, when a
problem must be located, and fixed.

Note : We are trying to help you, not fighting against you, in the long
term, its a win-win for everybody.



