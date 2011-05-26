Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1EZTBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:01:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57536 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab1EZTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:01:38 -0400
Date: Thu, 26 May 2011 12:01:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 26 (drivers/base/node.c)
Message-Id: <20110526120121.db0506de.randy.dunlap@oracle.com>
In-Reply-To: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DDEA38C.0013:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 16:39:41 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [The kernel.org mirroring is being slow today]


when CONFIG_PROC_FS is not enabled:

drivers/built-in.o: In function `node_read_vmstat':
node.c:(.text+0x56ffa): undefined reference to `vmstat_text'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
