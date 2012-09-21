Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2IURUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:20:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50496 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2IURUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:20:47 -0400
Date: Fri, 21 Sep 2012 13:20:45 -0400 (EDT)
Message-Id: <20120921.132045.951559071646755065.davem@davemloft.net>
To: jjolly@suse.com
Cc: linux-kernel@vger.kernel.org, venkat.x.venkatsubra@oracle.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rds: Error on offset mismatch if not loopback
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120920071134.GF14393@linux-tkdk.sfcn.org>
References: <20120920071134.GF14393@linux-tkdk.sfcn.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Jolly <jjolly@suse.com>
Date: Thu, 20 Sep 2012 01:11:34 -0600

> Attempting an rds connection from the IP address of an IPoIB interface
> to itself causes a kernel panic due to a BUG_ON() being triggered. Making
> the test less strict allows rds-ping to work without crashing the machine.
> 
> A local unprivileged user could use this flaw to crash the sytem.

Please read Documentation/SubmittingPatches to learn how to properly
submit a change, in particular your patch submission was missing a
proper signoff.

Thanks.
