Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab2AMVNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:13:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50580 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2AMVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:13:12 -0500
Date: Fri, 13 Jan 2012 13:12:48 -0800 (PST)
Message-Id: <20120113.131248.447541680022014759.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: roland@purestorage.com, venkat.x.venkatsubra@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120113185258.GB3904@oc1711230544.ibm.com>
References: <20120113181706.GA3904@oc1711230544.ibm.com>
	<20120113.102518.924916400773191073.davem@davemloft.net>
	<20120113185258.GB3904@oc1711230544.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Jan 2012 13:13:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 16:52:58 -0200

> On Fri, Jan 13, 2012 at 10:25:18AM -0800, David Miller wrote:
>> From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
>> Date: Fri, 13 Jan 2012 16:17:06 -0200
>> 
>> > Is this going through your tree? In patchwork, its state is "Not
>> > Applicable".
>> 
>> There was an active RDS maintainer, though I haven't seen patches
>> from that person in a while.
>> 
> 
> Hi, David.
> 
> Venkat is the current RDS maintainer and he has Acked the patch.

Not according to patchwork.  I don't see him reply at all to the
patch posting and give his explicit "Acked-by: "
