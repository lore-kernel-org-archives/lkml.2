Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0JEFrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:47:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488Ab0JEFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:47:15 -0400
Date: Mon, 04 Oct 2010 22:47:35 -0700 (PDT)
Message-Id: <20101004.224735.191411120.davem@davemloft.net>
To: hkchu@google.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, damian@tvk.rwth-aachen.de
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinsNEeTK=SrGpqEjF8VtZZWpiWydgSc+3M854pD@mail.gmail.com>
References: <20101001124830.9c35d36f.sfr@canb.auug.org.au>
	<AANLkTinsNEeTK=SrGpqEjF8VtZZWpiWydgSc+3M854pD@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerry Chu <hkchu@google.com>
Date: Thu, 30 Sep 2010 20:27:05 -0700

> In tcp_write_timeout():
> 
> if (retransmits_timed_out(sk, retry_until,
>             (1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV) ? 0 :
>             icsk->icsk_user_timeout, syn_set)) {
> 
> should be simplified to
> 
> if (retransmits_timed_out(sk, retry_until,
>     syn_set ? 0 : icsk->icsk_user_timeout, syn_set)) {

I've merged net-2.6 into net-next-2.6 and integrated this simplification
while doing so.
