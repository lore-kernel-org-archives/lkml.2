Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1ELXTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:19:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25112 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1ELXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:19:48 -0400
Date: Thu, 12 May 2011 16:19:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: linux-next: Tree for May 12 (ssb)
Message-Id: <20110512161914.e16be4d3.randy.dunlap@oracle.com>
In-Reply-To: <20110512142303.8117a0b6.sfr@canb.auug.org.au>
References: <20110512142303.8117a0b6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DCC6AFC.0061:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 14:23:03 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110511:


on i386 and x86_64 (many randconfigs fail with these errors):

drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
