Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0INPRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0INPRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:17:48 -0400
Date: Tue, 14 Sep 2010 11:17:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100914151723.GL26290@redhat.com>
References: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 04:31:20PM +0200, Andi Kleen wrote:
> 
> >
> > The proper approach would be not to add hacks to the NMI code but to
> > implement southbridge drivers - which would also have NMI callbacks.
> 
> BTW southbridges do less and less regarding PCI.
> 
> > These are unchartered waters, but variance in that space is reducing
> > systematically so it would be worth a shot.
> 
> You don't really need special drivers for AER -- it's fully standardized
> and works generically. I think the old PCI-X error bits Don was interested
> in were also all architectural.
> 
> The driver for the first is already there, just right now the
> information is not dumped in the right places.
> 
> There are a few platform specific error signals, but they tend
> to be rather obscure stuff. The "meat" is all in the standard.

>From what someone explained to me, the only platform that implements AER
correctly is Nehalem based ones.  So for AMD and Intel Core arches, AER is
not expected to work.  Is that incorrect?

Cheers,
Don
