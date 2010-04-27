Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0D0M4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:56:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753540Ab0D0M4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:56:35 -0400
Date: Tue, 27 Apr 2010 14:56:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
Message-ID: <20100427125624.GB3681@ucw.cz>
References: <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com>
 <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com>
 <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default>
 <4BD336CF.1000103@redhat.com>
 <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
 <4BD43182.1040508@redhat.com>
 <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default4BD44E74.2020506@redhat.com>
 <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Nevertheless, frontswap works great today with a bare-metal
> > > hypervisor.  I think it stands on its own merits, regardless
> > > of one's vision of future SSD/memory technologies.
> > 
> > Even when frontswapping to RAM on a bare metal hypervisor it makes
> > sense
> > to use an async API, in case you have a DMA engine on board.
> 
> When pages are 2MB, this may be true.  When pages are 4KB and 
> copied individually, it may take longer to program a DMA engine 
> than to just copy 4KB.
> 
> But in any case, frontswap works fine on all existing machines
> today.  If/when most commodity CPUs have an asynchronous RAM DMA
> engine, an asynchronous API may be appropriate.  Or the existing
> swap API might be appropriate. Or the synchronous frontswap API
> may work fine too.  Speculating further about non-existent
> hardware that might exist in the (possibly far) future is irrelevant
> to the proposed patch, which works today on all existing x86 hardware
> and on shipping software.

If we added all the apis that worked when proposed, we'd have
unmaintanable mess by about 1996.

Why can't frontswap just use existing swap api?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
