Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1ITWL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:11:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1ITWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:11:26 -0400
Subject: Re: [PATCH] tg3: fix VLAN tagging regression
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kasper Pedersen <kernel@kasperkp.dk>
Cc: Jesse Gross <jesse@nicira.com>, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1316556533.5832.1.camel@edumazet-laptop>
References: <4E78FC38.7040903@kasperkp.dk>
	 <20110920210929.GA9652@mcarlson.broadcom.com>
	 <CAEP_g=9V=5zHqwz710TSuRSqTdo1kqkKF2VEEV6K3Tv1zupegg@mail.gmail.com>
	 <4E790C5E.5000000@kasperkp.dk>  <1316556533.5832.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 00:11:14 +0200
Message-ID: <1316556674.5832.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 septembre 2011 à 00:08 +0200, Eric Dumazet a écrit :

> Thanks for finding this bug, this hit me last day on a BCM5755M but I
> had no time to investigate.
> 

I meant a BCM5715S, but its probably a generic bug anyway ;)




