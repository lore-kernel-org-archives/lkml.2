Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0FAIXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:23:10 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51738
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755309Ab0FAIXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:23:06 -0400
X-SpamScore: -4
X-BigFish: VPS-4(z78cMzzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L3BTY1-01-R7M-02
X-M-MSG: 
Date: Tue, 1 Jun 2010 10:23:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Dan Carpenter <error27@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
       Dave Jones <davej@redhat.com>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] x86, cacheinfo: dereferences before check
Message-ID: <20100601082305.GA10650@aftab>
References: <20100601071126.GF5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100601071126.GF5483@bicker>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Tue, Jun 01, 2010 at 03:11:27AM -0400

> This moves a couple dereferences after the checks in
> show_cache_disable() and store_cache_disable().  These were introduced
> fairly recently in 9350f982e4: "x86, cacheinfo: Reorganize AMD L3 cache
> structure"

Yes, this is correct, thanks. However I have a couple of patches which
rewrite and cleanup this section even more and was waiting for the merge
window to close before sending out. Stay tuned...

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

