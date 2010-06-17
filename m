Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0FQPwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:52:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48396
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760267Ab0FQPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:52:48 -0400
Date: Thu, 17 Jun 2010 08:52:58 -0700 (PDT)
Message-Id: <20100617.085258.104046759.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: mchan@broadcom.com, JBottomley@novell.com, vapier@gentoo.org,
       netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100617234855R.fujita.tomonori@lab.ntt.co.jp>
References: <C27F8246C663564A84BB7AB3439772421B79CBCA21@IRVEXCHCCR01.corp.ad.broadcom.com>
	<20100617230435J.fujita.tomonori@lab.ntt.co.jp>
	<20100617234855R.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 17 Jun 2010 23:50:36 +0900

> Oops, some typos.

I've applied the patch with the typos fixed, thanks!
