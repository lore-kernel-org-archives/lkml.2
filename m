Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0EYObU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:31:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44304 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab0EYObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:31:18 -0400
Date: Tue, 25 May 2010 16:31:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: BUG: unable to handle kernel paging request
Message-ID: <20100525143120.GA18018@kryptos.osrc.amd.com>
References: <201005231829.32106.M4rkusXXL@web.de>
 <201005232244.41977.M4rkusXXL@web.de>
 <20100523211717.GD1408@liondog.tnic>
 <201005251509.39495.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005251509.39495.M4rkusXXL@web.de>
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

From: Markus <M4rkusXXL@web.de>
Date: Tue, May 25, 2010 at 03:09:39PM +0200

> Had disabled swap (saw the string "swapper" and "page_fault"...) and
> now the problem does not show up anymore.

No, swapper is the idle task and I don't think it has anything to do
with the oops - it simply happens to be the currently running process
when the oops happens. And the kernel should be handling swapless
configurations just fine for the cost of slowing down when RAM is
depleted or OOM killing a memory hog.

> Dont know, if its now "fixed", but is it possible that raid1 and swap
> on top does not really work? Normal system usage (auto-detected raid1,
> add swap by fstab, regularly running a check and perhaps a resync).

Enabling swap on raid1 might need a bit more work, see here:
http://www.linuxjournal.com/article/5898

Anyways, let me know what happens and especially if it appears again.
Now you say it doesn't happen anymore but le me ask: is this still the
gentoo kernel or is it a vanilla one?

Thanks.

-- 
Regards/Gruss,
Boris.
