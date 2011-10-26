Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab1JZNzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:55:42 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:55421 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1JZNzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:55:40 -0400
X-ASG-Debug-ID: 1319637339-03d6a50f2a213fe0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4EA81141.90008@fusionio.com>
Date: Wed, 26 Oct 2011 15:55:13 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/4] block: xen-blkback: use API provided
 by xenbus module to map rings
References: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com> <1319107519-2253-3-git-send-email-david.vrabel@citrix.com> <20111026134706.GA21283@phenom.dumpdata.com>
X-ASG-Orig-Subj: Re: [Xen-devel] [PATCH 2/4] block: xen-blkback: use API provided
 by xenbus module to map rings
In-Reply-To: <20111026134706.GA21283@phenom.dumpdata.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1319637339
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.78456
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-26 15:47, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 20, 2011 at 11:45:17AM +0100, David Vrabel wrote:
>> The xenbus module provides xenbus_map_ring_valloc() and
>> xenbus_map_ring_vfree().  Use these to map the ring pages granted by
>> the frontend.
> 
> Jens,
> 
> This patch paves the way for two other patches that are in the akpm's
> MMU area of expertise.  In other words, the last patch in this series
> (which should go through akpm's tree or mine with his Ack) depends on
> this one.
> 
> I can split this patchset in three different pieces - one for you, one
> for david miller, and one for akpm. But I was hoping to have it as one
> nice GIT PULL for Linus - hence I am wondering if it is OK if I get
> your Ack and do it through my tree?

Sure, that'd be fine.

-- 
Jens Axboe

