Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2FLUzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:55:51 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59394 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2FLUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:55:49 -0400
Date: Tue, 12 Jun 2012 22:56:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612205609.GF11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
 <20120612190720.GA11137@aftab.osrc.amd.com>
 <1339529614.31548.104.camel@twins>
 <20120612194900.GC11137@aftab.osrc.amd.com>
 <4FD7A687.3040500@zytor.com>
 <20120612203730.GE11137@aftab.osrc.amd.com>
 <4FD7A99F.8030007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD7A99F.8030007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:42:07PM -0700, H. Peter Anvin wrote:
> I personally don't know of any valid use case for per-core loads, and
> it sounds like a horrid idea.

Vehemently agreed.

However, last time we talked about Ingo mentioned some possibility
of having different microcode versions on different CPUs:
http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00749.html

Hmm...

> And yes, I would prefer a single sysfs file, or better yet a plain old
> device node.

Also agreed.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
