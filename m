Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1HQVG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:06:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1HQVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:06:27 -0400
Date: Wed, 17 Aug 2011 17:05:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v3 3/8] kdump: Add size to elfcorehdr kernel parameter
Message-ID: <20110817210554.GD14813@redhat.com>
References: <20110812134849.748973593@linux.vnet.ibm.com>
 <20110812134907.325789470@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812134907.325789470@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 03:48:52PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently only the address of the pre-allocated ELF header is passed with
> the elfcorehdr= kernel parameter. In order to reserve memory for the header
> in the 2nd kernel also the size is required. Current kdump architecture
> backends use different methods to do that, e.g. x86 uses the memmap= kernel
> parameter. On s390 there is no easy way to transfer this information.
> Therefore the elfcorehdr kernel parameter is extended to also pass the size.
> This now can also be used as standard mechanism by all future kdump
> architecture backends.

Michael,

This version looks much better. A quick question. Who parses this
elfcorehdr= parameter in s390 and how do we make sure these headers are not
overwritten.

Thanks
Vivek
