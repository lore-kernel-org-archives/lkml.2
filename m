Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab2HVXHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219Ab2HVXHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:07:11 -0400
Date: Thu, 23 Aug 2012 01:06:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>
Subject: Re: [PATCH 33/36] autonuma: powerpc port
Message-ID: <20120822230628.GL8107@redhat.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
 <1345647560-30387-34-git-send-email-aarcange@redhat.com>
 <1345672907.2617.44.camel@pasglop>
 <1345676194.13399.1.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345676194.13399.1.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Thu, Aug 23, 2012 at 08:56:34AM +1000, Benjamin Herrenschmidt wrote:
> What I mean here is that it's fine as a proof of concept ;-) I don't
> like it being in a series aimed at upstream...
> 
> We can try to flush out the issues, but as it is, the patch isn't
> upstreamable imho.

Well there's no real urgency to merge the ppc64 support immediately. I
will move it at the end of the patchset. Until the ppc64 patch is
applied you simply cannot set AUTONUMA=y but there's no regression
whatsoever.

> As for finding PTE bits, I have a few ideas we need to discuss, but
> nothing simple I'm afraid.

Sure we can discuss it.
