Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0HZHJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:09:20 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44629 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0HZHJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:09:17 -0400
Date: Thu, 26 Aug 2010 09:09:15 +0200
From: Andreas Mohr <andi@lisas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100826070915.GA19129@rhlx01.hs-esslingen.de>
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema> <4C7588FB.4050001@zytor.com> <20100825225036.GV4762@const.famille.thibault.fr> <4C75AFFC.5090601@zytor.com> <20100826064549.GA3353@pema> <4C760FEE.1000309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C760FEE.1000309@zytor.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 11:55:42PM -0700, H. Peter Anvin wrote:
> On 08/25/2010 11:45 PM, Sebastien Hinderer wrote:
> > 00:00.0 Host bridge: Cyrix Corporation PCI Master
> > 	Flags: bus master, medium devsel, latency 0
> > 
> 
> Good grief ... these clowns didn't even program the subsystem ID?  Could
> you verify with lspci -vv -n?

Given the very non-standard environment as compared to a modern PC,
perhaps it's a good idea to tend towards establishing a standard
"pseudo-DMI" detection method for old-style "PC standard" hardware?
(which could support functions for checking a BIOS signature
at a defined, well-known BIOS memory location,
or functions for a VGA BIOS signature, or detecting certain standardized
BIOS flag words).
If a PC simply lacks all usual modern methods, then it's us (Linux)
who has to provide an utmost reliable fallback mechanism,
since that would still be much better than having raw, unverified
driver access.

Andreas Mohr
