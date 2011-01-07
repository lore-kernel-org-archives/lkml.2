Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1AGJTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:19:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:41374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab1AGJTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:19:14 -0500
Date: Fri, 7 Jan 2011 10:19:12 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT question - am I doing it correctly?
Message-ID: <20110107091911.GB1891@tiehlicka.suse.cz>
References: <4D1B6066.9000701@example.com>
 <20110103134807.GA3911@tiehlicka.suse.cz>
 <4D25F611.9040802@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D25F611.9040802@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-01-11 18:04:17, Piotr Hosowicz wrote:
> On 03.01.2011 14:48, Michal Hocko wrote:
> >On Wed 29-12-10 17:23:02, Piotr Hosowicz wrote:
> >>Hello,
> >
> >Hi,
> >
> >>
> >>Everytime I git pull tyhe Linus' sources but before I build I apply
> >>Peter Zijlstra's fixes, Takashi Iwai's sources and Dave Miller's
> >>sources. The sequence is:
> >>
> >># the Linus' sources
> >>git pull
> >>
> >># external sources
> >>git remote add some_name git://some_URL.git
> >>
> >># update
> >>git remote update
> >>
> >>Then configure and I build. I noticed that especially Peter's
> >>git-update very quickly, not as long as they did before.
> >>
> >>Is my procedure correct? I am new to GIT.
> >
> >What do you want to achieve?
> 
> I would like to have everything from Linus tree + additions from
> mmotm for example.

Andrew maintains mmotm as a quilt tree AFAIK, though there is some
initiative to have also a git tree which mirrors it
(http://lwn.net/Articles/311677/).  Btw. mmotm contains Linus tree (from
certain point of time).

Anyway, you can add what-ever git tree as a new remote. This basically
means that you can fetch commits from that tree into your local git
"database" and checkout out any of them as a branch (please note that if
the remote shares commits with your trees then you commit just the
additional ones). 

If you add a remote it doesn't mean that you stack that tree on top of
the original one. It is all just about commits which have their parents
so they form a history (very roughtly). You will find more about remotes
here: http://progit.org/book/ch2-5.html.

> Regards,
> 
> Piotr Hosowicz
> 
> -- 
> Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
> - Jak d?ugo trwa?a wojna sze?ciodniowa mi?dzy Izraelem a Egiptem?
> - (po d?u?szym namy?le): Czterna?cie dni.
> NP: Peter Green Splinter Group - Big Change Is Gonna Come
> NB: 2.6.37

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
