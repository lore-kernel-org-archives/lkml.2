Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1AaW76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:59:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856Ab1AaW74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:59:56 -0500
Date: Mon, 31 Jan 2011 15:00:31 -0800 (PST)
Message-Id: <20110131.150031.70194609.davem@davemloft.net>
To: horms@verge.net.au
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for January 31 (ip_vs)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110131225727.GA23992@verge.net.au>
References: <20110131101829.b842da44.randy.dunlap@oracle.com>
	<20110131211846.GH2389@verge.net.au>
	<20110131225727.GA23992@verge.net.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Tue, 1 Feb 2011 09:57:28 +1100

> On Tue, Feb 01, 2011 at 08:18:47AM +1100, Simon Horman wrote:
>> On Mon, Jan 31, 2011 at 10:18:29AM -0800, Randy Dunlap wrote:
>> > On Mon, 31 Jan 2011 17:41:13 +1100 Stephen Rothwell wrote:
>> > 
>> > > Hi all,
>> > > 
>> > > Changes since 20110121:
>> > > 
>> > > The net tree lost its build failure.
>> > 
>> > 
>> > When CONFIG_SYSCTL is not enabled:
>> > 
>> > net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
>> > ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
>> > ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
>> 
>> Thanks, I'm looking into it.
> 
> On a related note, does IPVS need to handle the case
> where CONFIG_PROC_FS is not enabled?

Yes.
