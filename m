Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0LKXP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 18:15:57 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33376 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0LKXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 18:15:54 -0500
Date: Sat, 11 Dec 2010 15:15:02 -0800
From: Kees Cook <kees.cook@canonical.com>
To: mat <castet.matthieu@free.fr>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101211231502.GZ4464@outflux.net>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
 <20101211002750.GT4464@outflux.net>
 <20101211115735.21b616fe@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101211115735.21b616fe@mat-laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 11:57:35AM +0100, mat wrote:
> http://marc.info/?l=linux-security-module&m=129105456828505&w=2

Ah-ha! Thanks for the pointer. So, instead of the other explicit jump_table
fix, can this get pushed into tip?

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
