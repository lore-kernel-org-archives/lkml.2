Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1HEKUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:20:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1HEKUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:20:14 -0400
Date: Fri, 05 Aug 2011 03:19:53 -0700 (PDT)
Message-Id: <20110805.031953.239005825626336696.davem@davemloft.net>
To: mingo@elte.hu
Cc: jpirko@redhat.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, REVERT] Re: [forcedeth bug] Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110805101625.GA11502@elte.hu>
References: <20110801151308.GA31256@elte.hu>
	<20110804215354.GA7056@elte.hu>
	<20110805101625.GA11502@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 05 Aug 2011 03:19:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Aug 2011 12:16:25 +0200

> I have reverted the two forcedeth commits:
> 
>   0891b0e08937: forcedeth: fix vlans
>   3326c784c9f4: forcedeth: do vlan cleanup
> 
> and also reverted two vlan commits that the pre-cleanup driver 
> depended on:
> 
>   ffcf9b767293: vlan: kill vlan_gro_frags and vlan_gro_receive
>   7890a5b9cbfd: vlan: kill ndo_vlan_rx_register
> 
> and this finally gave me a working forcedeth driver. I've attached 
> the working revert below.

Jiri please diagnose this immediately otherwise I will have to apply
Ingo's reverts.

Ingo has been reporting this regression for days and you haven't said
anything.  That's not acceptable.
