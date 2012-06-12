Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2FLTsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:48:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59086 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2FLTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:48:39 -0400
Date: Tue, 12 Jun 2012 21:49:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612194900.GC11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
 <20120612190720.GA11137@aftab.osrc.amd.com>
 <1339529614.31548.104.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339529614.31548.104.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:33:34PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 21:07 +0200, Borislav Petkov wrote:
> > Nice, this is the initrd cpio thing, cool, no changes needed for the
> > bootloader. Ping me when you have something ready so that I can start
> > testing it here too. 
> 
> What do people like me do that don't use initrd like nonsense?

I haven't seen the code yet but I'd assume you could add only the ucode
as an initrd image to the bootloader using "initrd... ". Then you'd only
need to be able to load initrds.

Also, I'd assume we need some of the current functionality to be able to
load ucode without rebooting the box.

But why, do you see a better option for how to tell the kernel to load a
binary blob early at boot?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
