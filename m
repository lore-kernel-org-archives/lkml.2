Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1GOJGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:06:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:57974 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1GOJGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:06:00 -0400
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1310718056.2586.275.camel@twins>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310718056.2586.275.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 19:05:23 +1000
Message-ID: <1310720723.4968.309.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 10:20 +0200, Peter Zijlstra wrote:
> But but but but, that get_user_pages(.write=1, .force=0) should result
> in a COW break, getting our own writable page.
> 
> What is this e500 thing smoking that this doesn't work? 

Right. That should have triggered the cow & flushed the TLB entry.... 

Cheers,
Ben.


