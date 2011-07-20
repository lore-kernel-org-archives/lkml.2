Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1GTRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:37:38 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:33095 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752703Ab1GTRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:37:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jgI9pFAVM1maNhDGSNRS12gHK1sCaRHEXxID7r3tVc5AZ0p
 u89lsmA9SJPA1E8I43AvxSXzFvmxSgTjBDd.qDuY3qf43a5abSjsDq7Ry.k6
 6nLrEyZbjT8dbcIjxqMB4MBWoYn7wDUtZCyhAl3P6wBSXEubl0jvSC9QFMXw
 gRFhEElBhR5S37Z4bH49DZ6JO1yTjTT7g4mBnU5DPhLE_qgnd44aDHonqs9G
 uHlEKCWw7T4X2kdSF33abV72LC6sfJ.CC2cS6tzvCsA1d5HH4JDoNKHyBmNW
 FJ7jxSxDdQpegjCus502mV2EagHLfhVVTiNuxO7idsWEkCRDp
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 12:37:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <alpine.DEB.2.00.1107202028050.2847@tiger>
Message-ID: <alpine.DEB.2.00.1107201237190.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home>  <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> 
 <alpine.DEB.2.00.1107200950270.1472@router.home>  <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1107201033080.1472@router.home>  <1311177362.2338.57.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1107201114480.1472@router.home>
  <1311179465.2338.62.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1311181463.2338.72.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1107201212140.1472@router.home> <alpine.DEB.2.00.1107202028050.2847@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Pekka Enberg wrote:

> On Wed, 20 Jul 2011, Eric Dumazet wrote:
> > > [PATCH v2] slab: shrinks sizeof(struct kmem_cache)
>
> On Wed, 20 Jul 2011, Christoph Lameter wrote:
> > This will solve the issue for small nr_cpu_ids but those with 4k cpus will
> > still have the issue.
> >
> > Acked-by: Christoph Lameter <cl@linux.com>
>
> Applied, thanks! Do we still want the __GFP_REPEAT patch from Konstantin
> though?

Those with 4k cpus will be thankful I guess.

