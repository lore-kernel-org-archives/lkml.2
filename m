Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2LABCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:02:13 -0500
Received: from scrye.com ([75.148.32.185]:37370 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2LABCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:02:12 -0500
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Enumerate the guidelines for stable patches.
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <gr4na1u02.fsf@dworkin.scrye.com>
	<20121201005225.GA19767@kroah.com>
Date: Fri, 30 Nov 2012 18:02:09 -0700
In-Reply-To: <20121201005225.GA19767@kroah.com> (Greg KH's message of "Fri, 30 Nov 2012 16:52:25 -0800")
Message-ID: <gip8m1t66.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> Is this really needed?  For the large majority of the stable
> patches, specifically enumerating this isn't a big deal, it's a tiny
> patch, and if you think I'll remember to tell you which specific
> clause you didn't follow, then you think I have more spare time than
> I really do.

Yeah, it was largely tongue-in-cheek.  :)

Although a hint of "not upstream" would have been helpful.  You
obviously have the checklist in your head, and you (presumably) have a
your formletter automated; it just seems that, as busy as the
maintainers are, trading an extra 2s of your time for an hour of a
contributor's time would sometimes be the right thing.

Regardless, you're the one doing the work, not me.  (And you're an
outright angel, compared to some other high-level maintainers, so I
should simply count myself lucky.)

> Sorry, but no, I don't think this patch is ok, especially that S15
> clause, nice try :)

Can't fault a guy for trying.  (Or, hopefully, can't fault him much...)

Have a good weekend,
t.
