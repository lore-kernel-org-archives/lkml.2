Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1ECKqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:46:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52483 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ECKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:46:23 -0400
Date: Tue, 3 May 2011 12:46:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Shawn Nock <nock@nocko.org>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Subject: Re: GPF, 39-rc5
Message-ID: <20110503104620.GA18648@gere.osrc.amd.com>
References: <m362pvg3wm.fsf@nocko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m362pvg3wm.fsf@nocko.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 11:22:33AM -0400, Shawn Nock wrote:
> 
> IBM Thinkpad x120e (AMD Fusion E-350).
> 
> How to reproduce: There is a primary problem (I haven't been able to
> capture it yet), that causes the system to hang.

Right, this is the interesting part: how exactly do you trigger this?
Does it happen with 2.6.38? Can you try enabling netconsole and see
whether you catch anything (Documentation/networking/netconsole.txt)?
BIOS update?

> The PC speaker emits a tone and I cannot return to a text console. The
> logs show nothing for this problem... however, rebooting after this
> panic seems to reliably (4/5) cause the following GPF:

This could be very well some garbled state that's being restored causing
the fxrstor #GP.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
