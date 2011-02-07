Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1BGNQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:16:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1BGNQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:16:42 -0500
Date: Mon, 7 Feb 2011 14:16:36 +0100
From: Matthias Hopf <mhopf@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: castet.matthieu@free.fr, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, rjw@sisk.pl,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Message-ID: <20110207131636.GD29925@suse.de>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	castet.matthieu@free.fr, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-security-module@vger.kernel.org, rjw@sisk.pl,
	Andrew Morton <akpm@linux-foundation.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <4D473FD5.1090903@free.fr>
 <20110201080223.GB20372@elte.hu>
 <1296566732.4d4809cc1f963@imp.free.fr>
 <20110202062632.GA12256@elte.hu>
 <4D4CA3FD.6000901@zytor.com>
 <1296924395.4d4d7eeb6f1fe@imp.free.fr>
 <4D4F8019.2090104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4F8019.2090104@zytor.com>
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 06, 11 21:16:09 -0800, H. Peter Anvin wrote:
> Here is my cleaned-up version of Matthieu's patch... please test so we
> can commit it as soon as possible.

This works as well, tested against Linus' master from today (which
doesn't work).

Tested-By: Matthias Hopf <mhopf@suse.de>

> From 0b327f122ccfbbb28f2c22834916f12d03fc2a06 Mon Sep 17 00:00:00 2001
> From: H. Peter Anvin <hpa@zytor.com>
> Date: Sun, 6 Feb 2011 19:58:38 -0800
> Subject: [PATCH] x86, nx: Mark the ACPI resume trampoline code as +x

Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de
