Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2AMSZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:25:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49469 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab2AMSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:25:29 -0500
Date: Fri, 13 Jan 2012 10:25:18 -0800 (PST)
Message-Id: <20120113.102518.924916400773191073.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: roland@purestorage.com, venkat.x.venkatsubra@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120113181706.GA3904@oc1711230544.ibm.com>
References: <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
	<CAL1RGDVEqr9XzzcpG6wK49e209JtrhXGayFa5Qnz_NziLinR-g@mail.gmail.com>
	<20120113181706.GA3904@oc1711230544.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Jan 2012 10:25:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 16:17:06 -0200

> Is this going through your tree? In patchwork, its state is "Not
> Applicable".

There was an active RDS maintainer, though I haven't seen patches
from that person in a while.
