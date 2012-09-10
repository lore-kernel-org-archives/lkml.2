Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2IJR3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:29:24 -0400
Received: from relais.videotron.ca ([24.201.245.36]:9393 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2IJR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:29:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 13:29:21 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
In-reply-to: <20120910164815.GB8238@arm.com>
Message-id: <alpine.LFD.2.02.1209101322140.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <201209071928.09999.arnd@arndb.de> <20120910164815.GB8238@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Catalin Marinas wrote:

> On Fri, Sep 07, 2012 at 08:28:09PM +0100, Arnd Bergmann wrote:
> > On Friday 07 September 2012, Catalin Marinas wrote:
> > > +
> > > +/*
> > > + *	dmac_inv_range(start,end)
> > 
> > all of these appear to be unused now. Can you remove them?
> 
> They aren't currently used but I expect some partners to make use of
> them on their private development. I could drop them from the upstream
> branch temporarily.

Depends.  If your expectation from those partners is a real probability 
then it is best to keep a skeleton in place for them to use, otherwise 
they might get ... creative.  If this is just wild speculation then you 
should drop it.


Nicolas
