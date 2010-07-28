Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0G1QtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:49:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14744 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0G1QtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:49:13 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432Nzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6A1DO-02-RBT-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 18:48:15 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kulikov Vasiliy <segooon@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
Message-ID: <20100728164815.GG16250@aftab>
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280335185-23265-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>
Date: Wed, Jul 28, 2010 at 12:39:44PM -0400

> mcheck_init_device() poorly handles errors. If any request fails
> unregister and free everything.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: Borislav Petkov <Borislav.Petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

