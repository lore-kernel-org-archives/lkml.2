Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DSVjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:39:44 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:46944 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753702Ab1DSVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:39:43 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .3T8CT8VM1niOG5tiuDmDfolx.tGKnBrfpJ9D5OBLbUXWSn
 7UdcLc6ttrGDYzmDBFJdfQ8Y4ii.MBefwavA9_kO9YtYa3qR60tPtXfN63f5
 FcKYNuA8Yk9q7con2p7Fxq_sjmooiHuSi6lCi5w0FHDBGUSb7WPp_uUV0HSK
 kWNuZwrBEio_awgBnxE3QuDCax5ufwrUGGEtmHSBcSxV6MxzO2v0A9HBQGkt
 _X9iWLCuw47Rb30xowmAggL87sr2XW3uf2yHt_zUME7Ra.tkVnUCgQufoXJ_
 ijJH8cf3TR8bVn75y8bMaiwyKe9O7Cf6CINLtCoisfAh3RgsL
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Apr 2011 16:39:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303248103.11237.16.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104191627040.23077@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>  <alpine.LSU.2.00.1104171952040.22679@sister.anvils>  <20110418100131.GD8925@tiehlicka.suse.cz>  <20110418135637.5baac204.akpm@linux-foundation.org>  <20110419111004.GE21689@tiehlicka.suse.cz> 
 <1303228009.3171.18.camel@mulgrave.site>  <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>  <1303233088.3171.26.camel@mulgrave.site>  <alpine.DEB.2.00.1104191213120.17888@router.home>  <1303235306.3171.33.camel@mulgrave.site> 
 <alpine.DEB.2.00.1104191254300.19358@router.home>  <1303237217.3171.39.camel@mulgrave.site>  <alpine.DEB.2.00.1104191325470.19358@router.home>  <1303242580.11237.10.camel@mulgrave.site>  <alpine.DEB.2.00.1104191530040.23077@router.home>
 <1303248103.11237.16.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, James Bottomley wrote:

> > I guess DISCONTIGMEM is typically used together with NUMA. Otherwise we
> > would have run into this before.
>
> Which bit of my telling you that six architectures already use it this
> way did you not get?  I'm not really interested in reconciling your
> theories with how we currently operate.  If you want to require NUMA
> with DISCONTIGMEM, fine, we'll just define SLUB as broken if that's not
> true ... that will fix my boot panic reports.

Which part of me telling you that you will break lots of other things in
the core kernel dont you get? If you were able to get to a command prompt
with SLAB then lets all be happy for as long as it lasts.


