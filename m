Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0F3RCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:02:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47313 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0F3RCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:02:03 -0400
Date: Wed, 30 Jun 2010 10:01:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: werner@guyane.yi.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: 2.6.35-rc1   classmate-laptop.c  poroblem
Message-Id: <20100630100142.25f8d365.randy.dunlap@oracle.com>
In-Reply-To: <1277527970.7800@guyane.yi.org>
References: <1277527970.7800@guyane.yi.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C2B7885.0176:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 01:52:50 -0300 (GFT) werner@guyane.yi.org wrote:

> On 31/Mai/2010 12:48 werner@sys-linux.yi.org wrote ..
> > 
> > 
> > drivers/built-in.o: In function `cmpc_ipml_remove':
> > classmate-laptop.c:(.text+0x671548): undefined reference to `rfkill_unregister'
> > classmate-laptop.c:(.text+0x671550): undefined reference to `rfkill_destroy'
> > drivers/built-in.o: In function `cmpc_ipml_add':
> > classmate-laptop.c:(.text+0x67163f): undefined reference to `rfkill_alloc'
> > classmate-laptop.c:(.text+0x671650): undefined reference to `rfkill_register'
> > classmate-laptop.c:(.text+0x67165c): undefined reference to `rfkill_destroy'
> > drivers/built-in.o: In function `cmpc_rfkill_query':
> > classmate-laptop.c:(.text+0x6716db): undefined reference to `rfkill_set_sw_state'
> > make: [.tmp_vmlinux1] Error 1 (ignored)


Yep, patch sent and queued.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
