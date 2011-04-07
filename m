Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1DGPF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:05:58 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:15243 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1DGPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:05:56 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAF9L-02-2N0-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 17:00:59 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110407150059.GY23633@amd.com>
References: <1302164789-31887-1-git-send-email-joerg.roedel@amd.com>
 <Pine.LNX.4.44L0.1104071034070.2147-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104071034070.2147-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 10:35:33AM -0400, Alan Stern wrote:
> On Thu, 7 Apr 2011, Joerg Roedel wrote:
> 
> > Booting 2.6.38 on my test machine produces a lockdep warning
> > from the usb_amd_find_chipset_info() function:
> 
> When posting revised patches, you need to indicate this fact in the
> email Subject: line.  For example:
> 
> 	[PATCH v.2] USB host: Fix lockdep warning in AMD PLL quirk
> 
> Otherwise people reading the email won't know which patch it refers to.

Yes, I usually do this when I post patch series. For single patches I
just send what 'git format-patch' gives me. I should probably edit that
output in the future on single patches.
(This is btw. actually v3, sorry that I forgot to Cc you on v2)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

