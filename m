Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0FNNAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:00:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54986 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0FNNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:00:30 -0400
Date: Mon, 14 Jun 2010 15:00:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100614130039.GA4618@kryptos.osrc.amd.com>
References: <201005271944.09541.toralf.foerster@gmx.de>
 <201005311555.56791.toralf.foerster@gmx.de>
 <20100531141058.GB4915@aftab>
 <201006141149.24647.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006141149.24647.toralf.foerster@gmx.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf Förster <toralf.foerster@gmx.de>
Date: Mon, Jun 14, 2010 at 11:49:24AM +0200

> Borislav Petkov wrote at 16:10:58
> > Did you do 'make mrproper' before rebuilding UML with it?
> 
> Today I started with a clean git tree (cloned Linus tree) and got this :

Right, I kinda missed that line, now it makes sense.

Linus' tree doesn't contain the fix yet - rather it is in -tip:
http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6

You can easily cherry-pick it from there and retest.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
