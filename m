Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2IUS6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:58:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2IUS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:58:50 -0400
Date: Fri, 21 Sep 2012 14:58:48 -0400 (EDT)
Message-Id: <20120921.145848.1437653204908742943.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120921113009.29a296b6405b96b4d3c05f84@canb.auug.org.au>
References: <20120921113009.29a296b6405b96b4d3c05f84@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 21 Sep 2012 11:30:09 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/usb/qmi_wwan.c between commit 9db273f45686 ("net:
> qmi_wwan: adding Huawei E367, ZTE MF683 and Pantech P4200") from the
> net tree and commit bd877e489126 ("net: qmi_wwan: use a single bind
> function for all device types") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, this should be resolved over the weekend as I plan
to do a merge during this time.
