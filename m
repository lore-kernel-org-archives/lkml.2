Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0CVEAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:00:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56943
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714Ab0CVEAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:00:01 -0400
Date: Sun, 21 Mar 2010 21:00:23 -0700 (PDT)
Message-Id: <20100321.210023.209981130.davem@davemloft.net>
To: yinghai@kernel.org
Cc: benh@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA6EA62.1030603@kernel.org>
References: <1269155601-18247-7-git-send-email-yinghai@kernel.org>
	<1269225435.8599.70.camel@pasglop>
	<4BA6EA62.1030603@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You really aren't listening to us at all.

We told you a thousand times to investigate using LMB for all of
this.

Instead you are posting the sparc64 conversion to the e820 stuff
again.

That action means you absolutely don't value our feedback at all.

You seem to really not care what a mess you are (unnecessarily)
making.
