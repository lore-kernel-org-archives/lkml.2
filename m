Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2BPD3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:29:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:42102 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab2BPD3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:29:30 -0500
Message-ID: <1329362944.3772.45.camel@pasglop>
Subject: Re: [PATCH 6/12] arch/powerpc: remove references to cpu_*_map.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 14:29:04 +1100
In-Reply-To: <4F3B790F.1040907@linux.vnet.ibm.com>
References: <1329281884.20466.rusty@rustcorp.com.au>
	 <4F3B790F.1040907@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 14:51 +0530, Srivatsa S. Bhat wrote:
> On 02/15/2012 10:28 AM, Rusty Russell wrote:
> 
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > This has been obsolescent for a while; time for the final push.
> > 

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Want me to stick that in -powerpc ? If yes, now or -next ?

Cheers,
Ben.

