Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1ARRSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:18:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47897 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1ARRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:18:22 -0500
Date: Tue, 18 Jan 2011 09:17:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 18 (__modver_version_show)
Message-Id: <20110118091749.ac5823df.randy.dunlap@oracle.com>
In-Reply-To: <20110118122139.6c2a6f2f.sfr@canb.auug.org.au>
References: <20110118122139.6c2a6f2f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 12:21:39 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Reminder: do not add any v2.6.39 material to your linux-next included
> trees until after v2.6.38-rc1 is released.
> 
> Changes since 20110115:


I'm seeing this on several builds (i386 and x86_64):

lib/built-in.o:(__modver+0x8): undefined reference to `__modver_version_show'
lib/built-in.o:(__modver+0x2c): undefined reference to `__modver_version_show'

It looks like the compiler or linker is dropping that function from the
build since it cannot see any references to it...
At least __modver_version_show is not in the kernel/params.o file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
