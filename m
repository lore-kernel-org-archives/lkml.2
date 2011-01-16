Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab1APFUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:20:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787Ab1APFUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:20:53 -0500
Date: Sat, 15 Jan 2011 21:21:26 -0800 (PST)
Message-Id: <20110115.212126.115922222.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH net-next 0/8] vmxnet3 fixes and enhancements
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
References: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas N Bhatewara <sbhatewara@vmware.com>
Date: Fri, 14 Jan 2011 16:59:20 -0800

> The following series fixes bugs and enhances functionality in the
> vmxnet3 driver.
> 
> ---
> 
> Shreyas N Bhatewara (8):
>       vmxnet3: fix ring size update
>       vmxnet3: Preserve the MAC address configured by ifconfig
>       vmxnet3: Enable HW Rx VLAN stripping by default
>       vmxnet3: Provide required number of bytes in first SG buffer
>       vmxnet3: Make ethtool handlers multiqueue aware
>       vmxnet3: Disable napi in suspend, reenable in resume.
>       vmxnet3: Add locking for access to command register
>       vmxnet3: Dont allocate extra MSI-x vectors

All applied, thanks.
