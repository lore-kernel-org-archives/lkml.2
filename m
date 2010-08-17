Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0HQFf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:35:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36550
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab0HQFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:35:27 -0400
Date: Mon, 16 Aug 2010 22:35:44 -0700 (PDT)
Message-Id: <20100816.223544.104039309.davem@davemloft.net>
To: dm@chelsio.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C6A1C7C.7070004@chelsio.com>
References: <4C6A1C7C.7070004@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitris Michailidis <dm@chelsio.com>
Date: Mon, 16 Aug 2010 22:22:04 -0700

> This may be similar to the problems IA-64 had last week as a result of
> the rwsem changes, eg see commit
> 01d69a82e1d3c938da16bf55aab000672243aa24.  I see
> arch/sparc/include/asm/atomic_64.h uses ints with atomic64_t, which
> was a problem for IA-64.  Just guessing.

Thanks Dimitris I'll take a look.
