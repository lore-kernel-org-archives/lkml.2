Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0JAMW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:22:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:33082 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab0JAMWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:22:55 -0400
Subject: Re: [PATCH 01/18] powerpc: Add ability to build little endian
 kernels
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        Albert Herranz <albert_herranz@yahoo.es>, paulus@samba.org,
        Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
In-Reply-To: <AANLkTimdV2FTEhcKXcM_+k23PBFTR5KvyjqEGxzzX72Q@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
	 <AANLkTimdV2FTEhcKXcM_+k23PBFTR5KvyjqEGxzzX72Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 22:22:22 +1000
Message-ID: <1285935742.2463.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 07:40 -0400, Josh Boyer wrote:
> Have you tested this support with a userspace containing floating
> point instructions?  I wonder if CONFIG_MATH_EMULATION is going to
> need work at all, and if the boards with an actual FPU (440EP, 440EPx,
> 460EX, etc) would have issues. 

That's one of the things on the TODO list. We've tested that on a 44x
with no FPU so far and made sure we built without math emu.

Cheers,
Ben.


