Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2CNP7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:59:37 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38611 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2CNP7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:59:34 -0400
Date: Wed, 14 Mar 2012 16:59:06 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Adalbert Dawid <dawid@rinux.net>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: Kernel Panic with Rawtherapee (mce related)
Message-ID: <20120314155906.GA25286@aftab>
References: <1331678930.11814.16.camel@erde.fritz.box>
 <4F60B0E3.6020503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F60B0E3.6020503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:23:23PM +0530, Srivatsa S. Bhat wrote:
> [Adding some Cc's]
> 
> On 03/14/2012 04:18 AM, Adalbert Dawid wrote:
> 
> > Hello,
> > 
> > in the last few weeks I've been having several crashes when processing
> > raw photo files with rawtherapee. AFAICT this always happend under
> > (high) cpu load (e.g. when exporting a file to jpg), however I am not
> > able to narrow it down a certain operation.
> > 
> > I am running debian testing on a Core 2 Duo E8400 (not overclocked or
> > anything) with 8GB of ram on an Asus board.
> > 
> > $ uname -a
> > Linux erde 3.2.0-1-amd64 #1 SMP Fri Feb 17 05:17:36 UTC 2012 x86_64 GNU/Linux
> > 
> > Is anyone able to tell from the stack trace ("screenshot" attached) what
> > might be going on?

You're getting a bunch of machine checks, the last one of them being
fatal (Process Context Corrupt bit is set) causing the machine to panic.

Tony will probably be able to help you further in decoding what exactly
those MC0_STATUS and MC5_STATUS values mean. <tease>Well, if we had MCE
decoding in the kernel that would've not been an issue... :-)</tease>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
