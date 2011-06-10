Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1FJPoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:44:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab1FJPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:44:31 -0400
Date: Fri, 10 Jun 2011 08:44:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 26 (drivers/base/node.c)
Message-Id: <20110610084405.c34a166d.randy.dunlap@oracle.com>
In-Reply-To: <20110526120121.db0506de.randy.dunlap@oracle.com>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
	<20110526120121.db0506de.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DF23BD7.00FC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 12:01:21 -0700 Randy Dunlap wrote:

> On Thu, 26 May 2011 16:39:41 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The kernel.org mirroring is being slow today]
> 
> 
> when CONFIG_PROC_FS is not enabled:
> 
> drivers/built-in.o: In function `node_read_vmstat':
> node.c:(.text+0x56ffa): undefined reference to `vmstat_text'

Hi Greg,

How do you want this build problem fixed?  (still around in
linux-next-20110610)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
