Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab0D3Rsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:48:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51481 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933601Ab0D3Rsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:48:35 -0400
Date: Wed, 28 Apr 2010 07:55:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
Message-ID: <20100428055538.GA1730@ucw.cz>
References: <4BD16D09.2030803@redhat.com>
 <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com>
 <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com>
 <4BD1B626.7020702@redhat.com>
 <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default>
 <4BD3377E.6010303@redhat.com>
 <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default4BD43033.7090706@redhat.com>
 <ce808441-fae6-4a33-8335-f7702740097a@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce808441-fae6-4a33-8335-f7702740097a@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Seems frontswap is like a reverse balloon, where the balloon is in
> > hypervisor space instead of the guest space.
> 
> That's a reasonable analogy.  Frontswap serves nicely as an
> emergency safety valve when a guest has given up (too) much of
> its memory via ballooning but unexpectedly has an urgent need
> that can't be serviced quickly enough by the balloon driver.

wtf? So lets fix the ballooning driver instead?

There's no reason it could not be as fast as frontswap, right?
Actually I'd expect it to be faster -- it can deal with big chunks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
