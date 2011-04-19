Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1DSVsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:48:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39046 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab1DSVsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:48:38 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.1104191627040.23077@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>
	 <alpine.LSU.2.00.1104171952040.22679@sister.anvils>
	 <20110418100131.GD8925@tiehlicka.suse.cz>
	 <20110418135637.5baac204.akpm@linux-foundation.org>
	 <20110419111004.GE21689@tiehlicka.suse.cz>
	 <1303228009.3171.18.camel@mulgrave.site>
	 <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>
	 <1303233088.3171.26.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191213120.17888@router.home>
	 <1303235306.3171.33.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191254300.19358@router.home>
	 <1303237217.3171.39.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191325470.19358@router.home>
	 <1303242580.11237.10.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191530040.23077@router.home>
	 <1303248103.11237.16.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104191627040.23077@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 16:48:36 -0500
Message-ID: <1303249716.11237.26.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 16:39 -0500, Christoph Lameter wrote:
> On Tue, 19 Apr 2011, James Bottomley wrote:
> 
> > > I guess DISCONTIGMEM is typically used together with NUMA. Otherwise we
> > > would have run into this before.
> >
> > Which bit of my telling you that six architectures already use it this
> > way did you not get?  I'm not really interested in reconciling your
> > theories with how we currently operate.  If you want to require NUMA
> > with DISCONTIGMEM, fine, we'll just define SLUB as broken if that's not
> > true ... that will fix my boot panic reports.
> 
> Which part of me telling you that you will break lots of other things in
> the core kernel dont you get?

I get that you tell me this ... however, the systems that, according to
you, should be failing to get to boot prompt do, in fact, manage it.

>  If you were able to get to a command prompt
> with SLAB then lets all be happy for as long as it lasts.

We can't re-engineer DISCONTIGMEM as a bug fix, so something like this
has to be done for stable regardless.

James


