Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1BARll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:41:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17395 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1BARlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:41:39 -0500
Date: Tue, 1 Feb 2011 09:16:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 1 (ip_vs)
Message-Id: <20110201091620.64536300.randy.dunlap@oracle.com>
In-Reply-To: <20110201153403.b3a251a3.sfr@canb.auug.org.au>
References: <20110201153403.b3a251a3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 15:34:03 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110131:


When CONFIG_IP_VS_PROTO_TCP is not set:

net/netfilter/ipvs/ip_vs_proto_sctp.c:1104: error: 'struct netns_ipvs' has no member named 'tcp_app_lock'
net/netfilter/ipvs/ip_vs_proto_sctp.c:1104: error: 'struct netns_ipvs' has no member named 'tcp_app_lock'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
