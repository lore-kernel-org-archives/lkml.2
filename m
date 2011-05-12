Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1ELViF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:38:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53162
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932771Ab1ELViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:38:04 -0400
Date: Thu, 12 May 2011 14:37:30 -0700 (PDT)
Message-Id: <20110512.143730.193713822.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH net-next] vmxnet3: Use single tx queue when
 CONFIG_PCI_MSI not defined
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1105100903110.1095@sbhatewara-dev1.eng.vmware.com>
References: <alpine.LRH.2.00.1105091715150.26660@sbhatewara-dev1.eng.vmware.com>
	<alpine.LRH.2.00.1105100903110.1095@sbhatewara-dev1.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Tue, 10 May 2011 09:13:56 -0700 (PDT)

> 
> Resending this patch with few changes.
> 
> 
> Avoid multiple queues when MSI or MSI-X not available
> 
> Limit number of Tx queues to 1 if MSI/MSI-X support is not configured in
> the kernel. This will make number of tx and rx queues equal when MSI/X 
> is not configured thus providing better performance.
> 
> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>

Applied, thanks.
