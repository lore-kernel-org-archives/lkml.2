Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1HEK0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab1HEK0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:26:13 -0400
Date: Fri, 5 Aug 2011 12:26:01 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, REVERT] Re: [forcedeth bug] Re: [GIT] Networking
Message-ID: <20110805102600.GC1928@minipsycho.orion>
References: <20110801151308.GA31256@elte.hu>
 <20110804215354.GA7056@elte.hu>
 <20110805101625.GA11502@elte.hu>
 <20110805.031953.239005825626336696.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805.031953.239005825626336696.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Aug 05, 2011 at 12:19:53PM CEST, davem@davemloft.net wrote:
>From: Ingo Molnar <mingo@elte.hu>
>Date: Fri, 5 Aug 2011 12:16:25 +0200
>
>> I have reverted the two forcedeth commits:
>> 
>>   0891b0e08937: forcedeth: fix vlans
>>   3326c784c9f4: forcedeth: do vlan cleanup
>> 
>> and also reverted two vlan commits that the pre-cleanup driver 
>> depended on:
>> 
>>   ffcf9b767293: vlan: kill vlan_gro_frags and vlan_gro_receive
>>   7890a5b9cbfd: vlan: kill ndo_vlan_rx_register
>> 
>> and this finally gave me a working forcedeth driver. I've attached 
>> the working revert below.
>
>Jiri please diagnose this immediately otherwise I will have to apply
>Ingo's reverts.
>
>Ingo has been reporting this regression for days and you haven't said
>anything.  That's not acceptable.

Sorry, but first time I saw this was ~3hours ago. Looking at it
(reserving systems, compiling with ingo's config, etc) since then...

/me cannot be faster.

