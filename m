Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1BIWSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:18:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48314 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1BIWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:18:40 -0500
Date: Wed, 9 Feb 2011 14:16:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.38-rc4 (other bugs)
Message-Id: <20110209141650.10028e81.randy.dunlap@oracle.com>
In-Reply-To: <20110209.140115.183045242.davem@davemloft.net>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110209093656.2b23b80b.randy.dunlap@oracle.com>
	<20110209.140115.183045242.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D53129E.008F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Feb 2011 14:01:15 -0800 (PST) David Miller wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 9 Feb 2011 09:36:56 -0800
> 
> > 
> > There are also bugs or other oopses etc. with ipmi, x25 (rmmod hangs system),
> > and (usb gadget) g_audio, but I don't have logs for them yet...
> > Someone else could do those.
> 
> Randy if you could simply get a CPU program counter when the x25
> rmmod hang happens, I can probably fix it quickly.
> 
> But if you don't have time I can fiddle around with it myself.

I can probably get it this (WED.) evening.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
