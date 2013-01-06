Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3AFLrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:47:01 -0500
Received: from stringer.orebokech.com ([88.190.240.207]:43649 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3AFLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:46:59 -0500
From: Romain Francoise <romain@orebokech.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Major network performance regression in 3.7
Organization: orebokech dot com
References: <1357430523.1678.4901.camel@edumazet-glaptop>
	<20130106005053.GS16031@1wt.eu>
	<1357435276.1678.5067.camel@edumazet-glaptop>
	<20130106013027.GV16031@1wt.eu>
	<1357436430.1678.5111.camel@edumazet-glaptop>
	<1357437086.1678.5135.camel@edumazet-glaptop>
	<1357438591.1678.5205.camel@edumazet-glaptop>
	<20130106025256.GY16031@1wt.eu>
	<1357457724.1678.5941.camel@edumazet-glaptop>
	<20130106092435.GZ16031@1wt.eu> <20130106102525.GA22151@1wt.eu>
Date: Sun, 06 Jan 2013 12:46:58 +0100
In-Reply-To: <20130106102525.GA22151@1wt.eu> (Willy Tarreau's message of "Sun,
	6 Jan 2013 11:25:25 +0100")
Message-ID: <87wqvqlej1.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> That makes me think that I should try 3.8-rc2 since LRO was removed
> there :-/

Better yet, find a way to automate these tests so they can run continually
against net-next and find problems early...
