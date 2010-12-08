Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0LHQ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:28:08 -0500
Received: from www.tglx.de ([62.245.132.106]:44511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0LHQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:28:06 -0500
Date: Wed, 8 Dec 2010 17:27:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Edouard Gomez <ed.gomez@free.fr>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Thomas Backlund <tmb@mandriva.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
In-Reply-To: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com>
Message-ID: <alpine.LFD.2.00.1012081701130.2653@localhost6.localdomain6>
References: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Edouard Gomez wrote:

> # HG changeset patch
> # User Edouard Gomez <ed.gomez@free.fr>
> # Date 1291821505 -3600
> # Node ID 4d8b4b3a1d3c6034b86889fac38dd53e6579bb42
> # Parent  53e51000d59963c8ca408db4db619d2c82374c5e
> x86: Dell Precision WorkStation 690 reboot quirk
> 
> This Dell workstation gets stuck on reboot unless booted with
> the paremeter reboot=bios.
> 
> This patch has been submitted 3 times already to X86 ARCHITECTURE
> maintainers w/o any feedback so far. Trying my chance on the LKML.

Sorry, but I haven't seen this patch in my inbox and my mail server
log has only a single connection attempt to deliver mail from you on
Dec. 8 which ended up in one of my spam traps.

Cc'ing LKML (or some other relevant mailinglist) is recommended for
sending patches anyway. Documentation/SubmittingPatches says:
 
Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.

Thanks,

	tglx
