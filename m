Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1DLLNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:13:12 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:48821
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab1DLLNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:13:10 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zzbb2cK936eK179dN154dM1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJJDTQ-01-3IB-02
X-M-MSG: 
Date: Tue, 12 Apr 2011 13:13:00 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Borislav Petkov <bp@alien8.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110412111300.GE20607@amd.com>
References: <20110411163711.GA20607@amd.com>
 <Pine.LNX.4.44L0.1104111304080.1975-100000@iolanthe.rowland.org>
 <20110412064128.GC20607@amd.com>
 <4DA4308F.6060601@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DA4308F.6060601@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 06:59:27AM -0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 12-04-2011 10:41, Roedel, Joerg wrote:
> 
> >>> Hmm, I see how it can be done differently, but no real bug.
> 
> >> Never mind, you're right.  In the no-race case, the initial count is
> >> always going to be 0, and so incrementing info.probe_count is the right
> >> thing to do.
> 
> > Okay, cool. So now that we have settled on this I removed the last
> > occurence of '2.6.38' from the changelog and here is the result. No
> > code changes since v5.
> 
>     I've pointed out the mistake in the code that you didn't fix... :-(

Argh, sorry, I missed this comment from you. I'll fix this.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

