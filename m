Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0GMUdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:33:46 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:34867
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754946Ab0GMUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:33:44 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5IJQV-02-KKM-02
X-M-MSG: 
Date: Tue, 13 Jul 2010 22:32:53 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100713203253.GA9615@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <4C3CC6F2.7050406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C3CC6F2.7050406@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Jul 13, 2010 at 01:05:06PM -0700

> [Adding Borislav and Hans to the Cc: list]
> 
> Any objections?  Otherwise I'm going to queue this up in the urgent queue.

Yeah, I was staring at it already. And it looks ok at a first glance.
However, since you want to speed it up into urgent, I'd like to give it
a run at our X6 boxes tomorrow before ACKing it..

> On 07/13/2010 11:59 AM, Michal Schmidt wrote:
> > On my system with AMD Phenom II X6 I am seeing pauses at boot (usually during
> > udev startup) which require a key press to continue. It only happens if C1E is
> > enabled in the BIOS.

... and this is strange, I didn't experience anything like that on our
X6 boxes here couple of months ago. But maybe something got changed in
later kernels to trigger that behavior. Michal, what chipset is that and
do you have the latest BIOS on it?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

