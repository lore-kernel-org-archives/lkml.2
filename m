Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab2FAKpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:45:16 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58174 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab2FAKpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:45:11 -0400
Date: Fri, 1 Jun 2012 12:45:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 25/27] s390, smpboot: Use generic SMP booting
 infrastructure
Message-ID: <20120601104506.GB3535@osiris.boeblingen.de.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091604.31979.71351.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091604.31979.71351.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060110-2966-0000-0000-000004438531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 02:46:09PM +0530, Srivatsa S. Bhat wrote:
> Convert s390 to use the generic framework to boot secondary CPUs.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com (supporter:S390)
> Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jan Glauber <jang@linux.vnet.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/s390/kernel/smp.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 

Looks good to me.

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

