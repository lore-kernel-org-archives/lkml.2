Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2KIQUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:20:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab2KIQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:20:42 -0500
Date: Fri, 9 Nov 2012 17:20:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 -tip 3/3] AHCI: Support multiple MSIs
Message-ID: <20121109162012.GB31918@dhcp-26-207.brq.redhat.com>
References: <cover.1349517905.git.agordeev@redhat.com>
 <b9a66434759a77b2fa870565ab9708fc286d7368.1349517905.git.agordeev@redhat.com>
 <20121025090957.GA7424@gmail.com>
 <20121025092555.GF16350@dhcp-26-207.brq.redhat.com>
 <20121025093626.GG16350@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025093626.GG16350@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:36:26AM +0200, Alexander Gordeev wrote:
> On Thu, Oct 25, 2012 at 11:25:55AM +0200, Alexander Gordeev wrote:
> > On Thu, Oct 25, 2012 at 11:09:57AM +0200, Ingo Molnar wrote:
> > > Has Jeff acked this patch?
> > 
> > Yep,
> > http://lkml.indiana.edu/hypermail/linux/kernel/1210.0/00795.html
> 
> Ah.. sorry - Jeff acked v3, not the recent one.
> Jeff, would you keep your ack for this patch?

Hi Jeff,

Could you please review this patch?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
