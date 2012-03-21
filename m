Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2CUU5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:57:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2CUU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:57:07 -0400
Date: Wed, 21 Mar 2012 16:56:36 -0400 (EDT)
Message-Id: <20120321.165636.369272291402056641.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: Knut_Petersen@t-online.de, torvalds@linux-foundation.org, arekm@maven.pl,
        nitro@legroom.net, dilieto@lineone.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: override for PCI legacy power management
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
References: <4F69BE2E.7070903@t-online.de>
	<20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Mar 2012 13:56:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 21 Mar 2012 08:32:05 -0700

> Some BIOS's don't setup power management correctly (what else is
> new) and don't allow use of PCI Express power control. Add a special
> exception module parameter to allow working around this issue.
> Based on slightly different patch by Knut Petersen.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied and queued up for -stable.
