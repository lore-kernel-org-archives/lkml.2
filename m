Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1KSRVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:21:32 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:48842 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab1KSRVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:21:31 -0500
Date: Sat, 19 Nov 2011 18:21:27 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-pci@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
	(firewire-ohci)
Message-ID: <20111119172127.GA31915@nomi.cz>
References: <4BF7B147.9020502@s5r6.in-berlin.de> <20100522121212.GQ10452@parisc-linux.org> <1274553643.11551.17300.camel@macbook.infradead.org> <20100522120905.154ff932@jbarnes-x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100522120905.154ff932@jbarnes-x201>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

On Sat, May 22, 2010 at 12:09:05PM -0700, Jesse Barnes wrote:
> On Sat, 22 May 2010 19:40:43 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> > [...]
> > Yeah, the DMAR looks at the source-id in the PCIe transactions, and it
> > sounds like those are all 04:00.0. But we've probably set up the DMAR to
> > allow the transactions from 04:00.4, and then it naturally faults when a
> > "different" device actually ends up doing the transaction.
> > 
> > If you make the pci_find_upstream_pcie_bridge() function do the
> > appropriate thing for this device, does it then work as expected?
> > 
> > Whether that's a _sane_ thing to do or not is possibly more of a Jesse
> > question...
> 
> Well, if cardbus bridges tend to behave this way in general it would
> make sense to simply use the cardbus bride id everywhere, rather than
> the specific functions of the device.  Cc'ing Dominik.

Any news on this one? It is still an issue with current kernel on current
hardware (like my ThinkPad T420). :-(

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
