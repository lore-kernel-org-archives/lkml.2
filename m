Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030629Ab2CGTvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:37 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:49108 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030365Ab2CGTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:51:20 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 14:51:20 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/lkml
CC: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
In-Reply-To: Jason Baron's message of  Wednesday, 7 March 2012 13:50:37 -0500 <20120307185035.GA2409@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
	<3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
	<CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
	<20120307185035.GA2409@redhat.com>
X-Zippy-Says: Yow!  I want to mail a bronzed artichoke to Nicaragua!
Message-Id: <20120307194302.7BD142C0C3@topped-with-meat.com>
Date: Wed,  7 Mar 2012 11:43:02 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=qe1nvlo_i8AA:10
		a=kj9zAlcOel0A:10 a=JN-WcpLdH5c228sxgrsA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> well, sure, we can provide an arch interface, for this check. I'm more
> concerned with the general idea. If it seems ok, I can re-do this bit
> with an arch interface.

Anything based on strcmp is dismal.  VM_ALWAYSDUMP was nice and clean.
A hook along the lines of arch_vma_name would be clean enough I suppose.
In fact, there is only one instance today (tile) where arch_vma_name()!=NULL
wouldn't do just what you need.


Thanks,
Roland
