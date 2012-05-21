Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2EUJqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:46:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33008 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2EUJqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:46:06 -0400
Date: Mon, 21 May 2012 13:46:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521094601.GE7767@moon>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120518144153.GD8455@moon>
 <20120518154236.GA23406@dhcp-26-207.brq.redhat.com>
 <20120518155119.GG8455@moon>
 <20120519104725.GA18768@moon>
 <20120521071135.GA28930@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521071135.GA28930@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 09:11:36AM +0200, Alexander Gordeev wrote:
> 
> > p.s. Hope Suresh and Yinghai will take a look too. The thing which bothers
> > me is that we use LowPrio delivery mode, while there is no lowprio in
> > x2apic ipi messages and I assume the same should apply to ioapic generated
> > messages.
> 
> My understanding of the specification is LowestPrio is not supported only for
> IPIs on x2APIC. Can not imagine why IO-APICs need to be limited here. But let's
> hear what the guys think.

True. This limitation applies to IPIs only.

	Cyrill
