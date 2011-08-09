Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1HISGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:06:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:54670 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1HISGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,344,1309762800"; 
   d="scan'208";a="36846568"
Message-ID: <4E41772D.1070700@linux.intel.com>
Date: Tue, 09 Aug 2011 11:06:37 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [Patch] scm: Capture the full credentials of the scm sender
References: <1312841316.2576.49.camel@schen9-DESK>	 <1312857834.2531.15.camel@edumazet-laptop> <1312908512.2576.97.camel@schen9-DESK>
In-Reply-To: <1312908512.2576.97.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This patch corrects an erroneous update of credential's gid with uid
> introduced in commit 257b5358b32f17 since 2.6.36.


Please also add a Cc: stable@kernel.org

-Andi

