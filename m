Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0IXPzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:55:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0IXPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:55:01 -0400
Date: Fri, 24 Sep 2010 08:54:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 24 (block/blk-throttle)
Message-Id: <20100924085400.eb4f0ac4.randy.dunlap@oracle.com>
In-Reply-To: <20100924145537.bd092bfb.sfr@canb.auug.org.au>
References: <20100924145537.bd092bfb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 14:55:37 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100923:


on i386:

blk-throttle.c:(.text+0x1abb8): undefined reference to `__udivdi3'
blk-throttle.c:(.text+0x1b1dc): undefined reference to `__udivdi3'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
