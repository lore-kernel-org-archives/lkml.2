Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab0D3R3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:29:11 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758706Ab0D3R2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:28:44 -0400
Date: Thu, 29 Apr 2010 15:02:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
Message-ID: <20100429130231.GA1661@ucw.cz>
References: <4BD1A74A.2050003@redhat.com>
 <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com>
 <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default>
 <4BD336CF.1000103@redhat.com>
 <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
 <4BD43182.1040508@redhat.com>
 <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default4BD44E74.2020506@redhat.com>
 <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default20100427125624.GB3681@ucw.cz>
 <36b23d5c-ca25-44b5-be9f-b7ceaab0dd2e@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36b23d5c-ca25-44b5-be9f-b7ceaab0dd2e@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Stop right here. Instead of improving existing swap api, you just
> > create one because it is less work.
> > 
> > We do not want apis to cummulate; please just fix the existing one.
> 
> > If we added all the apis that worked when proposed, we'd have
> > unmaintanable mess by about 1996.
> > 
> > Why can't frontswap just use existing swap api?
> 
> Hi Pavel!
> 
> The existing swap API as it stands is inadequate for an efficient
> synchronous interface (e.g. for swapping to RAM).  Both Nitin
> and I independently have found this to be true.  But swap-to-RAM

So... how much slower is swapping to RAM over current interface when
compared to proposed interface, and how much is that slower than just
using the memory directly?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
