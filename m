Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0HYHOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:14:40 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24009
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab0HYHOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:14:37 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz8275bh8275dh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L7P5DJ-02-G8T-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 09:13:46 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Message-ID: <20100825071346.GA25816@aftab>
References: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
 <20100825063041.GA25259@aftab>
 <4C74C0FA.3010304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C74C0FA.3010304@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Aug 25, 2010 at 03:06:34AM -0400

> It doesn't matter on reboot, but the right thing would be to switch to
> the trampoline page table here.  Same with suspend.

Yeah, I do that in my other patch (http://lkml.org/lkml/2010/8/24/61)
which adds the initial_page_table and keeps swapper_pg_dir clear of low
mappings. I'll add Hugh's fix there too and will start testing to see
what happens :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

