Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2IIX32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:29:28 -0400
Received: from relais.videotron.ca ([24.201.245.36]:53157 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2IIX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:29:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sun, 09 Sep 2012 19:29:24 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
In-reply-to: <20120909172046.GB31430@game.jcrosoft.org>
Message-id: <alpine.LFD.2.02.1209091923180.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > +4. Call the kernel image
> > +------------------------
> > +
> > +Requirement: MANDATORY
> > +
> > +The decompressed kernel image contains a 32-byte header as follows:
> > +
> > +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> > +  u32 res0	= 0;		/* reserved */
> > +  u64 text_offset;		/* Image load offset */
> > +  u64 res1	= 0;		/* reserved */
> > +  u64 res2	= 0;		/* reserved */
> we need to have a magic to known it's a arm64 kernel

You have it: it's 0x14000008 at the beginning.

> > +
> > +The image must be placed at the specified offset (currently 0x80000)
> > +from the start of the system RAM and called there. The start of the
> > +system RAM must be aligned to 2MB.
> can we drop this

Drop what?
And why?


Nicolas
