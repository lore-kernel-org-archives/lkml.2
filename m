Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1JQNsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:48:12 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:30783 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQNsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:48:11 -0400
X-IronPort-AV: E=Sophos;i="4.69,359,1315180800"; 
   d="scan'208";a="8425136"
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20124.12795.279739.528005@mariner.uk.xensource.com>
Date: Mon, 17 Oct 2011 14:47:39 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1RE5NW-151309@chiark.greenend.org.uk>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
	<4E94E1E5.4070505@goop.org>
	<20111012101615.GA14966@aftab>
	<4E95D9E7.6090304@zytor.com>
	<4E95E7FE.6050302@goop.org>
	<m2n.s.1RE5NW-151309@chiark.greenend.org.uk>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes ("[Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen dom0"):
> On 10/12/2011 12:18 PM, Jeremy Fitzhardinge wrote:
> > But for right now, this patch seems like the pragmatic solution.
> 
> No.

This is a quite astonishing response.  At the moment, microcode
updates in Xen systems are _completely broken_ because they do not
happen at all.

The existing machinery in Linux is the way it is and you say it's no
good - how about we just remove it all too ?  Because that's what
you're suggesting is the proper course for Xen!

At the moment, Jeremy's patch is a significant improvement.  It is
quite unreasonable to block it because some pie-in-the-sky scheme for
doing it at boot time does not exist yet.

Either:
 (a) Jeremy's patch should go in
 (b) all after-boot microcode update code should be removed from Linux

Ian.
(very cross)
