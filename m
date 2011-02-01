Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1BARaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:30:17 -0500
Received: from stinky.trash.net ([213.144.137.162]:46381 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab1BARaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:30:15 -0500
Message-ID: <4D484323.1060404@trash.net>
Date: Tue, 01 Feb 2011 18:30:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hans Schillstrom <hans@schillstrom.com>
CC: Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 4/5] IPVS: Allow compilation with CONFIG_SYSCTL 	disabled
References: <7j2t3lt.112d3171f5f31f2acb18786b51a8e1ac@obelix.schillstrom.com>
In-Reply-To: <7j2t3lt.112d3171f5f31f2acb18786b51a8e1ac@obelix.schillstrom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.02.2011 18:11, schrieb Hans Schillstrom:
>> [PATCH 4/5] IPVS: Allow compilation with CONFIG_SYSCTL disabled
>> >
>> >This is a rather naieve approach to allowing PVS to compile with
>> >CONFIG_SYSCTL disabled.  I am working on a more comprehensive patch which
>> >will remove compilation of all sysctl-related IPVS code when CONFIG_SYSCTL
>> >is disabled.
>> >
>> >Cc: Hans Schillstrom <hans@schillstrom.com>
>> >Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>> >Signed-off-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
> Tested-by: Hans Schillstrom <hans@schillstrom.com>

Applied, thanks.
