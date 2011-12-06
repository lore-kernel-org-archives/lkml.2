Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1LFTxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:53:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7738 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1LFTxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:53:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 06 Dec 2011 11:52:50 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Cong Wang <amwang@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 6 Dec 2011 11:52:36 -0800
Subject: RE: [PATCH] highmem: Fix ARM build break due to __kmap_atomic rename
Thread-Topic: [PATCH] highmem: Fix ARM build break due to __kmap_atomic
 rename
Thread-Index: Acy0Txtdy+anM5ctT2CvQbzg2diNsQAAWAew
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B774A6@HQMAIL01.nvidia.com>
References: <1323197426-10815-1-git-send-email-swarren@nvidia.com>
 <alpine.LFD.2.02.1112061440050.2357@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1112061440050.2357@xanadu.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote at Tuesday, December 06, 2011 12:42 PM:
> On Tue, 6 Dec 2011, Stephen Warren wrote:
> > Git commit 37bfbb9 "highmem: kill all __kmap_atomic()" renamed
> > __kmap_atomic to kmap_atomic. However, arch/arm/include/asm/highmem.h
> > wasn't updated for that change. This change does so, and fixes the
> > ARM build break.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > This shows up in next-20111206 at least.
> 
> Commit 37bfbb9 doesn't show up in anything which is stable yet.  Would
> be best to ask the original author to fix his branch.

Yes, I assumed that Cong would squash this into his/her tree that's in
linux-next.

-- 
nvpublic

