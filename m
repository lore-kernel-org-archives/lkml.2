Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1AaSTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:19:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52033 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1AaSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:19:07 -0500
Date: Mon, 31 Jan 2011 10:18:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 31 (ip_vs)
Message-Id: <20110131101829.b842da44.randy.dunlap@oracle.com>
In-Reply-To: <20110131174113.8199f901.sfr@canb.auug.org.au>
References: <20110131174113.8199f901.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D46FD14.02B8:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 17:41:13 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110121:
> 
> The net tree lost its build failure.


When CONFIG_SYSCTL is not enabled:

net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
