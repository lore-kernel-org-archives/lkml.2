Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1LGOce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:32:34 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58021 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1LGOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:32:32 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275dhz2dh668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVU8E0-02-GFS-02
X-M-MSG: 
Date: Wed, 7 Dec 2011 15:32:23 +0100
From: Robert Richter <robert.richter@amd.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jerome Glisse <j.glisse@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Alex, Shi" <alex.shi@intel.com>, Dave Airlie <airlied@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, <tj@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111207143223.GX15738@erda.amd.com>
References: <20111121131531.GA1679@x4.trippels.de>
 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121153621.GA1678@x4.trippels.de>
 <20111123160353.GA1673@x4.trippels.de>
 <alpine.DEB.2.00.1111231004490.17317@router.home>
 <20111124085040.GA1677@x4.trippels.de>
 <20111201084437.GA1529@x4.trippels.de>
 <20111202194309.GA12057@homer.localdomain>
 <20111202200649.GA1603@x4.trippels.de>
 <20111202204820.GB1603@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111202204820.GB1603@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.11 21:48:20, Markus Trippelsdorf wrote:
> BTW I always see (mostly only on screen, sometimes in the logs):
> 
> [Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
> [Firmware Bug]: cpu 2, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
> [Firmware Bug]: using offset 1 for IBS interrupts
> [Firmware Bug]: workaround enabled for IBS LVT offset
> perf: AMD IBS detected (0x0000001f) 
> 
> But I hope that it is only a harmless warning. 
> (perf Instruction-Based Sampling)

Yes, the message always apears on AMD family 10h. Nothing to worry
about.

A patch is on the way to soften the message to not scare the people:

 http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=16e5294e5f8303756a179cf218e37dfb9ed34417

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

