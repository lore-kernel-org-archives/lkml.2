Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2FLVEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:04:16 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59432 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2FLVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:04:15 -0400
Date: Tue, 12 Jun 2012 23:04:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612210436.GG11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
 <20120612190720.GA11137@aftab.osrc.amd.com>
 <1339529614.31548.104.camel@twins>
 <20120612194900.GC11137@aftab.osrc.amd.com>
 <4FD7A687.3040500@zytor.com>
 <20120612203730.GE11137@aftab.osrc.amd.com>
 <4FD7A99F.8030007@zytor.com>
 <20120612205609.GF11137@aftab.osrc.amd.com>
 <4FD7AD6F.6010008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD7AD6F.6010008@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:58:23PM -0700, H. Peter Anvin wrote:
> There is a difference here. Mixed steppings or even mixed CPUs are,
> indeed, supported (even things like Nehalem + Westmere in the same
> system). However, the notion is that we should upload the *entire set*
> of microcodes to the kernel, and let it flash the appropriate one into
> each CPU.

Sure, the ucode driver both on Intel and AMD does that already by
looking at each patch in the blob. I'd expect no change to that
functionality.

> This may result in different version number on different CPUs.

Ok, understood.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
