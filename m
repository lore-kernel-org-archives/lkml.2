Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0C2VBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:01:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54040
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab0C2VBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:01:30 -0400
Date: Mon, 29 Mar 2010 14:01:31 -0700 (PDT)
Message-Id: <20100329.140131.118617762.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100329204931.GJ5101@nowhere>
References: <20100328043446.GA11748@nowhere>
	<20100329.130931.149161813.davem@davemloft.net>
	<20100329204931.GJ5101@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 22:49:33 +0200

> While building perf tools, or the kernel, or whatever, I often
> get the following error in the middle:
> 
> 	gcc: Internal error: Segmentation fault (program as)
> 
> And this in the logs:
> 
> 	[ 1429.477049] as[2658]: segfault at 4054dfa8 ip 0000000000020690 (rpc 00000000700adcf4) sp 00000000ffcbf008 
> error 30001 in as[10000+40000]

What distribution and binutils are you using?
