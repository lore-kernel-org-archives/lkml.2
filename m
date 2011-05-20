Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780Ab1ETLAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:00:05 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:54590 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934304Ab1ETLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:00:04 -0400
To: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 20 May 2011 13:00:02 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: David Miller <davem@davemloft.net>, <tsunanet@gmail.com>,
        <kuznet@ms2.inr.ac.ru>, <pekkas@netcore.fi>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
 <20110518.152653.1486764697527722925.davem@davemloft.net>
 <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
 <20110518.155200.801089483916944725.davem@davemloft.net>
 <20110518202025.GC4175@nuttenaction>
 <BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com>
Message-ID: <fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
User-Agent: RoundCube Webmail/0.1-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 May 2011 03:27:37 -0700, "H.K. Jerry Chu" wrote:

Hi Jerry

> Not sure how our various parameter tuning proposals deviate from the
"TCP
> over everything" principle?

For our environment it hurts because we _always_ have an initial RTO >1. I
understand and accept that 98% will benefit of this modification, no doubt
Jerry! Try to put yourself in our situation: imaging a proposal of an init
RTO modification to 0.5 seconds. Maybe because 98% of Internet traffic is
now localized and the RTO is average now 0.2 seconds. Anyway, this will
penalize your network always and this will be the situation for one of my
customer. I can live with that, I see the benefits for the rest of the
world. But I am happy to see a knob where I can restore the old behavior.
Maybe some other environments will benefit from a even lower or higher
initial RTO.

Hagen
