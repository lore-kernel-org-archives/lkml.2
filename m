Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2EUPeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:34:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48068 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2EUPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:34:33 -0400
Date: Mon, 21 May 2012 19:34:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521153428.GG7767@moon>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521145904.GA7068@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:59:04PM +0200, Ingo Molnar wrote:
> 
> When a device is generating ten thousand irqs a second then 
> round-robining the IRQs is equivalent to switching a CPU every 
> 100 usecs.
> 

As far as I remember it's even more complex, with lowprio it
might be not complete fair round-robin, since if focused
processor found then it'll be assigned to handle incoming
irq again.

	Cyrill
