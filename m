Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab2FBGOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 02:14:40 -0400
Received: from ozlabs.org ([203.10.76.45]:49729 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965056Ab2FBGOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 02:14:39 -0400
Date: Sat, 2 Jun 2012 16:14:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        linux-arch@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, rusty@rustcorp.com.au,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        Yong Zhang <yong.zhang0@gmail.com>, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org
Subject: Re: [PATCH 18/27] powerpc, smpboot: Use generic SMP booting
 infrastructure
Message-ID: <20120602061427.GA14048@pale.ozlabs.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091417.31979.6433.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091417.31979.6433.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 02:44:23PM +0530, Srivatsa S. Bhat wrote:
> From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> 
> Convert powerpc to use the generic framework to boot secondary CPUs.
> 
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Acked-by: Paul Mackerras <paulus@samba.org>
