Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2LQWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:07:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab2LQWHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:07:42 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI: Overriding ACPI tables via initrd only works with an initrd
Date: Mon, 17 Dec 2012 23:07:29 +0100
Message-ID: <1609943.YuhLsJhEU0@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50CF5FB4.8090305@zytor.com>
References: <1351694147-10904-1-git-send-email-trenn@suse.de> <20121217092802.GA31947@liondog.tnic> <50CF5FB4.8090305@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 10:08:52 AM H. Peter Anvin wrote:
> On 12/17/2012 01:28 AM, Borislav Petkov wrote:
> > Hi guys,
> > 
> > this one sanitizes the Kconfig entry prompt so can we pick it up for
> > -rc1 or later, please?
> 
> Hm... all these are actually cleanups or fixes for the stuff that is now
> upstream, I believe... as minor fixes I think these can be pushed
> post-rc1 if we don't get to them sooner but it looks like they are all
> needed.
This and another one are more or less minor cleanups, not
urgently needed.
I can repost them the next days.

Thanks hpa for helping to finally get this feature mainline.
It's a huge enhancement for developing and debugging
ACPI related stuff on Linux.

   Thomas
