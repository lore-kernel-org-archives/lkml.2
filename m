Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0DAJCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:02:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58376
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab0DAJCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:02:25 -0400
Date: Thu, 01 Apr 2010 02:02:26 -0700 (PDT)
Message-Id: <20100401.020226.94730746.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100401093831.GE5207@nowhere>
References: <20100401090608.GD5207@nowhere>
	<20100401.010903.05627158.davem@davemloft.net>
	<20100401093831.GE5207@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 1 Apr 2010 11:38:33 +0200

> It seems to happen with ld as well btw (not sure this is related
> though):
> 
> [ 3366.005962] ld[19041]: segfault at 10 ip 000000007010248c (rpc 00000000701023f8) sp 00000000ffda87c8 error 30001 
> in libbfd-2.18.0.20080103.so[700d8000+a0000]

It's data corruption coming either from the kernel or something
malfunctioning in libc is my guess, more likely the kernel.

