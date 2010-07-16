Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623Ab0GPFSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 01:18:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43786
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab0GPFSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 01:18:46 -0400
Date: Thu, 15 Jul 2010 22:19:02 -0700 (PDT)
Message-Id: <20100715.221902.13737987.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, ronghua@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [2/5] Interrupt
 control bitmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007150121400.25472@localhost.localdomain>
References: <alpine.LRH.2.00.1007131746370.32055@localhost.localdomain>
	<20100714.140433.59678649.davem@davemloft.net>
	<alpine.LRH.2.00.1007150121400.25472@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Thu, 15 Jul 2010 18:20:03 -0700 (PDT)

> Reposting the patch with the endianness fix.
> 
> ---
> 
> A new bit map 'intrCtrl' is introduced in the DriverShared area. The 
> driver Ashould update VMXNET3_IC_DISABLE_ALL bit before writing IMR.
> 
> Signed-off-by: Ronghua Zang <ronghua@vmware.com>
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Applied.
