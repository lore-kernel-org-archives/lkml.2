Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1K0WlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:41:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:53622 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1K0WlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:41:02 -0500
Message-ID: <1322433640.23348.2.camel@pasglop>
Subject: Re: [PATCH] perf events, powerpc: Add POWER7
 stalled-cycles-frontend/backend events
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <michael.neuling@au1.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 09:40:40 +1100
In-Reply-To: <4880.1315549581@neuling.org>
References: <4E5C6A7D.2010909@linux.vnet.ibm.com>
	 <25545.1315532289@neuling.org> <4E69AFCF.3040404@linux.vnet.ibm.com>
	 <4880.1315549581@neuling.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:26 +1000, Michael Neuling wrote:

> I agree, I think they match what Ingo is trying to achieve.
> 
> Can you add these descriptions to the patch and resubmit please?
> 
> If you can find similar events for power4/5/5+/6 that would be great too
> submit too.  
> 
> FWIW, the patch compiles and runs for me.  

I already put it in my next branch, but feel free to send a followup
patch adding some comments if you think that's worthwhile.

Cheers,
Ben.


