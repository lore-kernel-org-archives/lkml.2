Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0C2CCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:02:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41426
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab0C2CCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:02:12 -0400
Date: Sun, 28 Mar 2010 19:02:35 -0700 (PDT)
Message-Id: <20100328.190235.125554595.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100328043446.GA11748@nowhere>
References: <20100328043446.GA11748@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 28 Mar 2010 06:34:49 +0200

> I get kernel crashes each time I use perf with callchains
> on sparc 64.
> 
> It triggers with a simple:
> 
> 	perf record -a -f -g sleep 1
> 
> I'm attaching two different crashlogs, as it seem to happen
> randomly, and also my config.

Is your 'perf' a 64-bit or 32-bit binary.  How about the
'sleep' binary?
