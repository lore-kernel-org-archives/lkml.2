Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab1CCWdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:33:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56591 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800Ab1CCWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:32:59 -0500
Date: Thu, 3 Mar 2011 13:54:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: Re: linux-next: Tree for February 10 (netfilter)
Message-Id: <20110303135414.bfcabb2a.randy.dunlap@oracle.com>
In-Reply-To: <4D58DB20.5060401@trash.net>
References: <20110210180525.54ec83e9.sfr@canb.auug.org.au>
	<20110210095210.6fcf3011.randy.dunlap@oracle.com>
	<4D58DB20.5060401@trash.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D70170C.01BB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 08:34:56 +0100 Patrick McHardy wrote:

> On 10.02.2011 18:52, Randy Dunlap wrote:
> > On Thu, 10 Feb 2011 18:05:25 +1100 Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> [The kernel.org mirroring is being slow ...]
> >>
> >> Changes since 20110209:
> > 
> > 
> > xt_AUDIT.c:(.text+0x39ca9): undefined reference to `ipv6_skip_exthdr'
> > 
> > IPV6 is not enabled.
> > 
> > Full config file is attached.
> 
> Thomas, please have a look at this.


Ping.
This build error is still with us in linux-next 2011.0303...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
