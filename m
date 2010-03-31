Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0CaPbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:31:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0CaPbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:31:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
Date: Wed, 31 Mar 2010 16:30:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de, linux-usb@vger.kernel.org
References: <201003242240.54907.arnd@arndb.de> <201003291643.01214.arnd@arndb.de> <20100329201123.GG20695@one.firstfloor.org>
In-Reply-To: <20100329201123.GG20695@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311730.31379.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Bc+CSI2fKPjKYhHiGTZXDlT/tuQd3rg4DFGT
 UEjUvY71iBzigaSC+IsDOqF97H1bWNIF1CvSBJWneEORS89HHy
 0jUThdEGcd0Hq7kLsnQJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 March 2010, Andi Kleen wrote:
> > > > The patch looks correct, but I probably wouldn't bother with the rename,
> > > > and simply drop the BKL in the caller.
> > > 
> > > I think a rename is better, I take compile errors over subtle
> > > breakage any day.
> > 
> > ok, fine with me.
> 
> I updated the git tree removing the unneeded serial change. Feel free to pull.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git usb-bkl

Looks good to me. I guess it makes sense to merge this through Greg's USB
tree. AFAICT the only prerequisite to this series is to have CONFIG_BKL
enabled in Kconfig. Shall we add a that to 2.6.34 as 'def_bool y' for
preparation so we can queue up patches like this in maintainer trees?

	Arnd
