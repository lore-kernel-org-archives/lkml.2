Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab1JYOR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:17:27 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57010 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933550Ab1JYOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:17:26 -0400
Date: Tue, 25 Oct 2011 16:17:20 +0200
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/3] Add NumaChip quirk
Message-ID: <20111025161720.351c3be4@jbarnes-x220>
In-Reply-To: <alpine.LFD.2.02.1110251550430.21837@ionos>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
	<1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
	<alpine.LFD.2.02.1110251550430.21837@ionos>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 85.13.70.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 15:54:29 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Daniel,
> 
> On Tue, 18 Oct 2011, Daniel J Blueman wrote:
> 
> > Add quirk for Numascale's NumaChip to prevent resource conflicts.
> > 
> > v2:
> >  - [Daniel] rediffed and validated against 3.1-rc10
> > 
> > Signed-off-by: Steffen Persvold <sp@numascale.com>
> 
> So, who wrote that code? If Steffen, then you should put a From:
> .... when sending patches.
> 
> > Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> > ---
> >  drivers/pci/quirks.c    |   14 ++++++++++++++
> >  include/linux/pci_ids.h |    4 ++++
> >  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> Jesse,
> 
> can you take that or should I push it through x86 ?

I can pull it in.

Thanks,
Jesse
