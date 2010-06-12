Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab0FLEOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 00:14:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45284 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0FLEO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 00:14:29 -0400
Date: Sat, 12 Jun 2010 06:15:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, AMD: Extend support to future families
Message-ID: <20100612041504.GB14077@aftab>
References: <20100602182921.GA21557@aftab>
 <4C101B58.2090208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C101B58.2090208@zytor.com>
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
Date: Wed, Jun 09, 2010 at 06:53:12PM -0400

> On 06/02/2010 11:29 AM, Borislav Petkov wrote:
> > Extend support to future families, and in particular:
> > 
> > * extend direct mapping split of Tseg SMM area.
> > * extend K8 flavored alternatives (NOPS).
> > * rep movs* prefix is fast in ucode.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> This doesn't reflect any currently shipping hardware, right?

Not yet. And I'm assuming you're driving at tagging it for -stable?
If yes, I think a stable tag makes sense since this way the distros
will pick it up more easily and we most definitely will need to do the
backport later otherwise.

Do you need another version with the stable tag resent or is it easier
for you to edit the commit message of the one you have already?

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
