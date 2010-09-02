Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0IBQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:15:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41567 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0IBQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:15:15 -0400
Date: Thu, 2 Sep 2010 09:14:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 2 (printk question)
Message-Id: <20100902091448.9cf048a9.randy.dunlap@oracle.com>
In-Reply-To: <20100902161345.b634857f.sfr@canb.auug.org.au>
References: <20100902161345.b634857f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 16:13:45 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100901:


printk format warning question:

on X86_32, I see this warning:

/drivers/staging/xgifb/XGI_main_26.c:3421: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'unsigned int'

I changed the format spec to "%x", so no problem on X86_32, but X86_64 build now says:

drivers/staging/xgifb/XGI_main_26.c:3421: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'


What is the correct way to fix this?  a cast?  or is it a gcc problem?

> gcc --version
gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2)

# from fc11

I've seen this in a few other cases/places as well.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
