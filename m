Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab0KPW30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:29:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab0KPW3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:29:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Date: Tue, 16 Nov 2010 23:28:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20101114052138.GB2189@elf.ucw.cz> <20101116052634.GA30449@elf.ucw.cz> <20101116053236.GA30605@elf.ucw.cz>
In-Reply-To: <20101116053236.GA30605@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162328.35599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010, Pavel Machek wrote:
> On Tue 2010-11-16 06:26:34, Pavel Machek wrote:
> > Hi!
> > 
> > > > ...but there's enough -- or at least it was enough to fit previous
> > > > versions. 32-bit machine, so it has highmem.
> > > > 
> > > > System is in console mode, very lightly loaded.
> > > > 
> > > > Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
> > > > Swap:   779148k total,     2360k used,   776788k free,   546388k cached
> > > 
> > > Well, the swap is rather in short supply.  Below the 50% of RAM recommendation.
> > 
> > Well, but the biggest image we can write is not 50% of RAM, but 50% of
> > lowmem... and swap is nearly as big as lowmem in this case -- so this
> > machine is not misconfigured.
> 
> BTW swsusp.txt may need updating, it says:
> 
> echo N > /sys/power/image_size
> 
> before suspend (it is limited to 500 MB by default).

Yes, this needs to be updated.

Thanks,
Rafael
