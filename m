Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0C2Nan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:30:43 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925Ab0C2Nam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:30:42 -0400
Date: Mon, 29 Mar 2010 15:30:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC 03/15] PM / Hibernate: separate block_io
Message-ID: <20100329133031.GA26618@ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <4BAA98FC.9040302@crca.org.au> <4BAACC0A.2040009@crca.org.au> <201003252112.25204.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003252112.25204.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > How about some abbreviation of hibernate? "hib"?
> > 
> > On further reflection, how about "std" (suspend to disk)? I think that's 
> > less ugly than the 'hib' suggestion :)
> 
> But it also decodes as "standard" if someone is not in the right context. :-)
> 

Hmm, and when you are in really wrong context, you get rather nasty
diseases...

std_prepare() seems like rather bad idea :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
