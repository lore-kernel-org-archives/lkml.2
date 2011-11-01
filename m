Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1KAXfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:35:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38420 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1KAXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:35:16 -0400
Date: Tue, 01 Nov 2011 19:33:18 -0400 (EDT)
Message-Id: <20111101.193318.633990180703042035.davem@davemloft.net>
To: cesarb@cesarb.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, jgarzik@pobox.com, becker@scyld.com
Subject: Re: [PATCH] net/ethernet: sc92031 is not Realtek
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319581944-2707-1-git-send-email-cesarb@cesarb.net>
References: <1319581944-2707-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 01 Nov 2011 16:33:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Tue, 25 Oct 2011 20:32:24 -0200

> While the SC92031 could be found on fake "Realtek" NICs, it has no
> relationship to Realtek, and is actually from Silan.
> 
> Create a new subdirectory for silan and move sc92031 there.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Applied.
