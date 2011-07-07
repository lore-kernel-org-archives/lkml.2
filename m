Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1GGPMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:12:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38302 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GGPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:12:17 -0400
Date: Thu, 7 Jul 2011 08:12:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 7 (net/af_packet)
Message-Id: <20110707081202.6dddcbce.randy.dunlap@oracle.com>
In-Reply-To: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020A.4E15CCCC.0008:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 17:25:44 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> The next linux-next release will (probably) be next-20110718.
> 
> Changes since 20110706:


When CONFIG_INET is not enabled:

af_packet.c:(.text+0x3d130): undefined reference to `ip_defrag'
or
ERROR: "ip_defrag" [net/packet/af_packet.ko] undefined!

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
