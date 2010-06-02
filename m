Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0FBIiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:38:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21794 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0FBIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:38:47 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L3DPC9-01-KRY-02
X-M-MSG: 
Date: Wed, 2 Jun 2010 10:38:38 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Julia Lawall <julia@diku.dk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Message-ID: <20100602083837.GC21639@amd.com>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
 <20100601141529.0c99f22c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100601141529.0c99f22c.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Jun 01, 2010 at 05:15:29PM -0400, Andrew Morton wrote:
> The reason why these bugs occur is that we sprinkle multiple `return'
> statements inside the middle of non-trivial functions.  People miss
> some or fail to modify some when later changing locking rules and we
> gain bugs (or, similarly, resource leaks).

Right. I changed that in Julia's patch too before merging it into my
tree. It is already in -tip. See
http://git.kernel.org/tip/84fe6c19e4a598e8071e3bd1b2c923454eae1268

	Joerg


