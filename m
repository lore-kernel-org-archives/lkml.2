Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab1D2Q0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:26:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34662 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868Ab1D2Q0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:26:43 -0400
Date: Fri, 29 Apr 2011 09:26:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 29 (bpf_jit)
Message-Id: <20110429092632.26ff1e53.randy.dunlap@oracle.com>
In-Reply-To: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
References: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBAE6C0.003F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 13:19:40 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110428:


when CONFIG_MODULES is not enabled:

bpf_jit_comp.c:(.text+0x43cc2): undefined reference to `module_free'
(.text+0x4521a): undefined reference to `module_alloc'
(.text+0x453af): undefined reference to `module_free'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
