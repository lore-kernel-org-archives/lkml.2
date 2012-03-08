Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2CHKiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:38:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2CHKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:37:59 -0500
Message-ID: <4F588BDE.3080503@kernel.dk>
Date: Thu, 08 Mar 2012 11:37:18 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] powerpc: remove the legacy iSeries platform specific
 drivers
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 05:28 AM, Stephen Rothwell wrote:
> It would probably be easiest if all these patches were merged via the
> powerpc tree to eliminate any dependencies between them.  Their impact on
> generic code is very small.

Go ahead, no point in doing otherwise.

-- 
Jens Axboe

