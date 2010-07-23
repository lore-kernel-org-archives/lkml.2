Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab0GWQLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:11:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40482 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab0GWQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:11:20 -0400
Date: Fri, 23 Jul 2010 09:08:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, tj@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 23 (fscache)
Message-Id: <20100723090831.6af4a288.randy.dunlap@oracle.com>
In-Reply-To: <20100723164931.7bf2160f.sfr@canb.auug.org.au>
References: <20100723164931.7bf2160f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C49BEF6.0158:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 16:49:31 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100722:


when CONFIG_SYSCTL is not enabled:

fs/fscache/main.c:189: error: 'fscache_sysctl_header' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
