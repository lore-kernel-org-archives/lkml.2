Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2HOSm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:42:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48979 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2HOSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:42:26 -0400
Date: Wed, 15 Aug 2012 20:42:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: a.p.zijlstra@chello.nl, prasad.krishnan@gmail.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, emachado@linux.vnet.ibm.com
Subject: Re: [PATCH v3] Hardware breakpoints: Invoke __perf_event_disable()
 if interrupts are already disabled
Message-ID: <20120815184216.GC19716@somewhere>
References: <20120731134124.GD17078@somewhere.redhat.com>
 <20120802081635.5811.17737.stgit@localhost.localdomain>
 <502BDE3D.6070909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BDE3D.6070909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:07:01PM +0530, Naveen N. Rao wrote:
> Hi Frederick,
> Did you get a chance to take a look at this?
> 
> Regards,
> Naveen

Yeah, I'm ok with the patch. Peter, are you ok with it?

Thanks.
