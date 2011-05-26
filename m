Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1EZS4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:56:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab1EZS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:56:10 -0400
Date: Thu, 26 May 2011 14:56:01 -0400 (EDT)
Message-Id: <20110526.145601.735416831290933990.davem@davemloft.net>
To: justinmattock@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        greearb@candelatech.com
Subject: Re: [PATCH v3]net:8021q:vlan.c Fix pr_info to just give the vlan
 fullname and version. 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306219428-11528-1-git-send-email-justinmattock@gmail.com>
References: <1306219428-11528-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 May 2011 11:56:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>
Date: Mon, 23 May 2011 23:43:48 -0700

> The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init, 
> so that it prints out just the fullname of vlan and the version number.
> 
> before:
> 
> [   30.438203] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
> [   30.441542] All bugs added by David S. Miller <davem@redhat.com>
> 
> after:
> 
> [   31.513910] 802.1Q VLAN Support v1.8
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Applied, thanks Justin.
