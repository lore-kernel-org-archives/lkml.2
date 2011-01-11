Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1AKVqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:46:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61845 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1AKVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V8GpAtVZaCNuElNKCuSMetjkQCeI8xPiViK3EGjeQ7oQUQxp0EvlCI+prVvKPMIV6L
         joyb/ZHRn5KjhVMDHF+fnpDAbPrldBECuGQpjlLG4kYTlgNYEgPCLDymHQS5rjLxpmqI
         6cOLM4cHM72jflfxdNJ3IZ3ZIFe2e3NHz1ljg=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, jj@chaosbits.net, daniel.baluta@gmail.com,
        jochen@jochen.org, hagen@jauu.net, torvalds@linux-foundation.org,
        pavel@ucw.cz
In-Reply-To: <1294782117.17531.18.camel@wall-e>
References: <1294779020.16410.2.camel@wall-e>
	 <20110111.125254.133402589.davem@davemloft.net>
	 <1294780480.17388.2.camel@wall-e>
	 <20110111.131953.180400101.davem@davemloft.net>
	 <1294782117.17531.18.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 22:46:26 +0100
Message-ID: <1294782386.3447.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 janvier 2011 à 22:41 +0100, Stefani Seibold a écrit :

> Second, the design is may in your opinion poor. I like it. What is
> really poor is the kernel_...() socket functions, which are only simple
> wrapper of the system calls without any performance improvement, skb
> support and memory saving.
> 

The only thing you want is to have a callback to your own code to
deliver an decapsulated skb to your state machine.

Take a look at other layers on top of UDP

(L2TP comes to mind)



