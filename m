Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1HNBCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 21:02:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48614 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1HNBC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 21:02:28 -0400
Date: Sat, 13 Aug 2011 18:02:22 -0700 (PDT)
Message-Id: <20110813.180222.2091598025825238892.davem@davemloft.net>
To: jpirko@redhat.com
Cc: mguntsche@gmail.com, shemminger@vyatta.com,
        sebastian.belden@googlemail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: Bisected Gianfar in bridge not forwarding packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110810111947.GC1909@minipsycho.brq.redhat.com>
References: <CAMvAeqO2bLaPwmdW+c+7hz-ec=-tF6Z0EFBv=FA7+rU_QZ_wDA@mail.gmail.com>
	<CAMvAeqM-oH1UzxEp9PgO6ZP-AKtqosuMg5za25_X8DpPJMDX2w@mail.gmail.com>
	<20110810111947.GC1909@minipsycho.brq.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 13 Aug 2011 18:02:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 10 Aug 2011 13:19:48 +0200

> Subject: [patch net-2.6] gianfar: prevent buggy hw rx vlan tagging
> 
> On some buggy chips, "vlan tag present" flag is set which causes packet
> loss. Fix this by checking if rx vlan accel is enabled in features.
> 
> Reported-by: Michael Guntsche <mguntsche@gmail.com>
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Applied.
