Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1EPTfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:35:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23472 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1EPTfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:35:50 -0400
Date: Mon, 16 May 2011 12:35:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 16 (net/ipv4/ping)
Message-Id: <20110516123534.5d3a51b9.randy.dunlap@oracle.com>
In-Reply-To: <20110516151019.be338f1c.sfr@canb.auug.org.au>
References: <20110516151019.be338f1c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DD17C91.011A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110513:


when CONFIG_PROC_SYSCTL is not enabled:

ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
