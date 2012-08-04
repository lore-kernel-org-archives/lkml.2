Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2HDX5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:57:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2HDX5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:57:07 -0400
Date: Sat, 04 Aug 2012 16:57:03 -0700 (PDT)
Message-Id: <20120804.165703.2163110391266920101.davem@davemloft.net>
To: jan.ariyasu@gmail.com
Cc: vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.ariyasu@hp.com
Subject: Re: [PATCH 00/13] SCTP: Enable netns
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Ariyasu <jan.ariyasu@gmail.com>
Date: Sat,  4 Aug 2012 15:30:37 -0600

> The following set of patches enable network-namespaces for the SCTP protocol.
> 
> The multitude of global parameters are stored in a net_generic
> structure, and the bulk of the patches enable the protocol to access
> the parameters on a per-namespace basis.  The first five patches
> enable netns handling of the protocol, procfs and sysfs.
> 
> Signed-off-by: Jan Ariyasu <jan.ariyasu@hp.com>

Patch 02/13 didn't show up at all.
