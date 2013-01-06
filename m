Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3AFBVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 20:21:22 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48419 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab3AFBVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 20:21:20 -0500
Subject: Re: Major network performance regression in 3.7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130106005053.GS16031@1wt.eu>
References: <20130105214958.GA19814@1wt.eu>
	 <1357427926.1678.4771.camel@edumazet-glaptop>
	 <20130105232913.GQ16031@1wt.eu>
	 <1357430523.1678.4901.camel@edumazet-glaptop>
	 <20130106005053.GS16031@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jan 2013 17:21:16 -0800
Message-ID: <1357435276.1678.5067.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 01:50 +0100, Willy Tarreau wrote:

> Yes, I've removed all zero counters in this short view for easier
> reading (complete version appended at the end of this email). This
> was after around 140 GB were transferred :

OK I only wanted to make sure skb were not linearized in xmit.

Could you try to disable CONFIG_COMPACTION ?

( This is the other thread mentioning this : "ppoll() stuck on POLLIN
while TCP peer is sending" )




