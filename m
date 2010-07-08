Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0GHVeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:34:06 -0400
Received: from mail.anarazel.de ([217.115.131.40]:51105 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab0GHVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:34:05 -0400
Date: Thu, 8 Jul 2010 23:33:57 +0200
From: Andres Freund <andres@anarazel.de>
To: linux-kernel@vger.kernel.org
Subject: Re: INFO: rcu_sched_state detected stall on CPU
Message-ID: <20100708213357.GA21477@anarazel.de>
References: <20100708205113.GA15117@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708205113.GA15117@anarazel.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err,

> After deactivating all power saving mechanisms it seems to have gotten
> a bit more stable - it still crashes pretty reliably under
> io-load. Graphics-intensive work seems also be able trigger it
> reliably. The crashes also occured with the cheap on-board intel
> graphics card.
Its not a intel one, but aspeed... Remembered the wrong system. Sorry.

Also so that you dont have to read the full dmesg: Its 2.6.35-rc4
(reproduced it with 2.6.32 onwards).

Andres
