Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0KKRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:49:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27507 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0KKRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:49:07 -0500
Date: Thu, 11 Nov 2010 09:48:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tony Finch <dot@dotat.at>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 11 (unifdef)
Message-Id: <20101111094832.827aaab3.randy.dunlap@oracle.com>
In-Reply-To: <20101111125655.15fa7188.sfr@canb.auug.org.au>
References: <20101111125655.15fa7188.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:56:55 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101110:


Hi Tony,
For the last week or so, linux-next tree has generated this warning:

unifdef: linux-next-20101111/X32/usr/include/xen/privcmd.h.tmp: 79: Premature EOF (#if line 33 depth 1)

linux/include/xen/privcmd.h contains:

#ifndef __user
#define __user
#endif

and linux/X32/usr/include/xen/privcmd.h contains:

#ifndef #define #endif

!!


Is this a problem with privcmd.h or unifdef or ???

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
