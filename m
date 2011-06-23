Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1FWQOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:14:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27292 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab1FWQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:14:44 -0400
Date: Thu, 23 Jun 2011 09:14:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 23 (net)
Message-Id: <20110623091429.2d51b0f0.randy.dunlap@oracle.com>
In-Reply-To: <20110623155431.6bfe3b40.sfr@canb.auug.org.au>
References: <20110623155431.6bfe3b40.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E03666F.0118:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 15:54:31 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110622:
> 
> The powerpc allyesconfig (and probably others) is still broken because we
> now build the staging drivers and because of a commit in the net tree.
> The breakage in Linus' tree is fixed by one of Andrew's patches above.
> 
> The net tree gained 2 build failures that I have left (see above).


When CONFIG_INET is not enabled:

net/core/dev.c:2535: error: implicit declaration of function 'ip_is_fragment'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
