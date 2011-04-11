Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1DKGnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:43:35 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45666
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753707Ab1DKGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:43:34 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2cK1432N98dKzz1202hzzz32i637h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJH6OA-02-B9E-02
X-M-MSG: 
Date: Mon, 11 Apr 2011 08:43:20 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alan Stern <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110411064320.GH23633@amd.com>
References: <2DEEA3AB13739D45A22ADDB5086AEA0B013084C4@sshaexmb1.amd.com>
 <1302182044-3940-1-git-send-email-joerg.roedel@amd.com>
 <20110411062559.GA25536@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110411062559.GA25536@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 02:26:00AM -0400, Borislav Petkov wrote:
> On Thu, Apr 07, 2011 at 03:14:04PM +0200, Joerg Roedel wrote:
> > Booting 2.6.38 on my test machine produces a lockdep warning
> 
> You mean 2.6.39-rc2 right? I'm asking because I hit the same warning
> with 39-rc2 now too but it didn't appear with .38 - so it has to have
> snuck in after the merge window. If so, you don't need the stable tag.
> 
> Also, is this the final version wrt code design so that I can test too?

I hit this in the KVM branch and git-describe told me it is 2.6.38
based. So I guess this happens on 2.6.38 too, but I havn't tested plain
2.6.38. I do this and sent out a new version shortly which you can use
then. The new version addresses Alan Stern's latest comments.

	Joerg


