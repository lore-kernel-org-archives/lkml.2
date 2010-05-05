Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353Ab0EEAcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:32:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36117
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933687Ab0EEAc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:32:29 -0400
Date: Tue, 04 May 2010 17:32:36 -0700 (PDT)
Message-Id: <20100504.173236.104064409.davem@davemloft.net>
To: pthakkar@vmware.com
Cc: shemminger@vyatta.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       pv-drivers@vmware.com, sbhatewara@vmware.com
Subject: Re: RFC: Network Plugin Architecture (NPA) for vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100505001857.GQ8323@vmware.com>
References: <20100504230225.GP8323@vmware.com>
	<20100504170531.1e7122da@nehalam>
	<20100505001857.GQ8323@vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Thakkar <pthakkar@vmware.com>
Date: Tue, 4 May 2010 17:18:57 -0700

> The purpose of this email is to introduce the architecture and the
> design principles. The overall project involves more than just
> changes to vmxnet3 driver and hence we though an overview email
> would be better. Once people agree to the design in general we
> intend to provide the code changes to the vmxnet3 driver.

Stephen's point is that code talks and bullshit walks.

Talk about high level designs rarely gets any traction, and often goes
nowhere.  Give us an example implementation so there is something
concrete for us to sink our teeth into.
