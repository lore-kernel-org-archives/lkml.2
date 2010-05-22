Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0EVV0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 17:26:06 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33805 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab0EVV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 17:26:04 -0400
Date: Sat, 22 May 2010 22:26:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: bkl: Pushdowns for sound/oss ?
In-Reply-To: <20100521154659.GA2346@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1005222158340.4344@eddie.linux-mips.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain> <20100521144055.GB13174@linux-mips.org> <alpine.LFD.2.00.1005211613200.4344@eddie.linux-mips.org> <20100521154659.GA2346@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010, Ralf Baechle wrote:

> I've patched up what there to build without warnings but that doesn't
> make any less ugly or wrong.  I'm trying to motivate a few folks to
> offload the work from you; until that has happened it might be nice if this
> driver would stick around as some form of documentation.

 The driver is of less use as an OSS module than it would be with ALSA.  
It only offers one sample rate of 48kHz (that is the native frequency of 
the codec) and my experience is 44.1kHz or its aliquots are what most 
pieces of OSS client software expect (at least such that is not capable of 
resampling itself).

 I'm not sure it makes a lot of sense to keep this piece around -- the 
kernel repositories are not meant to lose their history IIUC, so the 
driver will be available from an older revision for the foreseeable future 
anyway.  This has happened to other drivers too, even those that were of 
actual interest to people.

> As for the grandchildren - is there something I haven't heared of yet?  :)

 Me neither, but I've thought I could perhaps borrow some from a friend or 
suchlike and consider the matter ticked off. ;)

  Maciej
