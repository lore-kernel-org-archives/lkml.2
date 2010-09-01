Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0IAQvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:51:14 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3191 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626Ab0IAQvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:51:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i2a8h5bep5bfs61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L82URB-02-4JU-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 18:50:02 +0200
From: Robert Richter <robert.richter@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH next&mainline] oprofile: fix build when CONFIG_PM is
 disabled
Message-ID: <20100901165002.GN22783@erda.amd.com>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
 <20100901094132.e734ad94.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100901094132.e734ad94.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.10 12:41:32, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Using do/while for a function-returning-a-value does not
> make gcc happy, so change it to a static inline function.
> (happens when CONFIG_PM is not enabled)
> 
> arch/x86/oprofile/nmi_int.c:784: error: expected expression before 'do'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I already sent a fix to Ingo that fixes this.

Will update my for-next branch as soon as it is applied in tip.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

