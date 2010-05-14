Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab0ENUwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:52:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab0ENUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:52:31 -0400
Date: Fri, 14 May 2010 13:52:39 -0700 (PDT)
Message-Id: <20100514.135239.149842985.davem@davemloft.net>
To: kaber@trash.net
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       jengelh@medozas.de, netfilter-devel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] netfilter: xt_TEE depends on NF_CONNTRACK
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BED8650.5040808@trash.net>
References: <20100514161407.740da901.sfr@canb.auug.org.au>
	<20100514101218.16cdb0ad.randy.dunlap@oracle.com>
	<4BED8650.5040808@trash.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 14 May 2010 19:20:16 +0200

> Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> 
>> Fix xt_TEE build for the case of NF_CONNTRACK=m and
>> NETFILTER_XT_TARGET_TEE=y:
>> 
>> xt_TEE.c:(.text+0x6df5c): undefined reference to `nf_conntrack_untracked'
>> 4x
>> 
>> Built with all 4 m/y combinations.
>> 
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:	Patrick McHardy <kaber@trash.net>
>> Cc:	Jan Engelhardt <jengelh@medozas.de>
> 
> Acked-by: Patrick McHardy <kaber@trash.net>
> 
> Dave, please apply directly. Thanks!

Done, thanks everyone.
