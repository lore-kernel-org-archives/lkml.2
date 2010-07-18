Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0GRVtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 17:49:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33839
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321Ab0GRVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 17:49:11 -0400
Date: Sun, 18 Jul 2010 14:49:27 -0700 (PDT)
Message-Id: <20100718.144927.216775656.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [3/5] Initialize
 link state at probe time
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007160050030.12503@localhost.localdomain>
References: <alpine.LRH.2.00.1007150125240.25472@localhost.localdomain>
	<20100715.224435.45920963.davem@davemloft.net>
	<alpine.LRH.2.00.1007160050030.12503@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Fri, 16 Jul 2010 00:51:14 -0700 (PDT)

> Initialize vmxnet3 link state at probe time
> 
> This change initializes the state of link at the time when driver is
> loaded. The ethtool output for 'link detected' and 'link speed'
> is thus valid even before the interface is brought up.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Applied.

I'm still (patiently) waiting for the formal resubmission of patch #4
so I can also then apply patch #5.  Please post it at your next
possible convenience.

Thanks.
