Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447Ab2EJSwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:52:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53399 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab2EJSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:52:32 -0400
Date: Thu, 10 May 2012 14:52:12 -0400 (EDT)
Message-Id: <20120510.145212.952914187213825433.davem@davemloft.net>
To: kernel@teksavvy.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, inguin@gmx.de
Subject: Re: [ 22/52] asix: Fix tx transfer padding for full-speed USB
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FAC08EF.6010805@teksavvy.com>
References: <20120510173134.851728856@linuxfoundation.org>
	<4FAC081D.5080202@teksavvy.com>
	<4FAC08EF.6010805@teksavvy.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 11:52:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <kernel@teksavvy.com>
Date: Thu, 10 May 2012 14:29:03 -0400

> Never mind.. I missed the skb_push(skb, 4) line
> that the diff doesn't show above.
> 
> Okay by me.

Do me a favor and provide this kind of feedback when the patch
gets originally submitted, not some time later when it happens
to make it's way into a -stable submission.
