Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0FMHCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:02:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53666 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0FMHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:02:45 -0400
Date: Sun, 13 Jun 2010 08:52:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, AMD: Extend support to future families
Message-ID: <20100613065243.GA21493@aftab>
References: <20100602182921.GA21557@aftab>
 <4C101B58.2090208@zytor.com>
 <20100612041504.GB14077@aftab>
 <4C13D051.4060903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C13D051.4060903@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, Jun 12, 2010 at 02:22:09PM -0400

> On 06/11/2010 09:15 PM, Borislav Petkov wrote:
> > 
> > Not yet. And I'm assuming you're driving at tagging it for -stable?
> > If yes, I think a stable tag makes sense since this way the distros
> > will pick it up more easily and we most definitely will need to do the
> > backport later otherwise.
> > 
> > Do you need another version with the stable tag resent or is it easier
> > for you to edit the commit message of the one you have already?
> > 
> 
> No, I'm not -- Linus is being really snippy about wanting regressions
> only this cycle, which this is not.

Yeah, so I heard :)

> Once .35 is out you can talk to Greg about -stable.

Right, so this is clearly .36 merge window material - I just thought I
should get it out as early as possible so that it gets tested.

And by the way, how about a tag which says which kernel is the patch
aimed at so that maintainers know what should go where. I mean, with
those gazillion patches on lkml one doesn't always know which is
regression, which is a new feature but should go in earlier so that it
catches the next merge window etc? I.e., something like:

Aimed-at: 2.6.36+

or for regressions

Aimed-at: 2.6.35-rc3

and maybe even a bug info

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=....

I'm afraid this is starting to sound like Ingo's Impact: tag, at least
semantically, which didn't get accepted. Hmm, anyway, I'll try adding
such an information in later patches.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
