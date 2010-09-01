Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0IATif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:38:35 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27321
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab0IATie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:38:34 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L832CF-01-JEN-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 21:33:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH next&mainline] oprofile: fix build when CONFIG_PM is
 disabled
Message-ID: <20100901193348.GP22783@erda.amd.com>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
 <20100901094132.e734ad94.randy.dunlap@oracle.com>
 <20100901165002.GN22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100901165002.GN22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.10 18:50:02, Robert Richter wrote:
> On 01.09.10 12:41:32, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Using do/while for a function-returning-a-value does not
> > make gcc happy, so change it to a static inline function.
> > (happens when CONFIG_PM is not enabled)
> > 
> > arch/x86/oprofile/nmi_int.c:784: error: expected expression before 'do'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I already sent a fix to Ingo that fixes this.
> 
> Will update my for-next branch as soon as it is applied in tip.

The patch is now upstream in urgent of the oprofile tree. For-next is
also updated.

Sorry for the trouble.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

