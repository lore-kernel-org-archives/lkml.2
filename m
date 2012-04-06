Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2DFXfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:35:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DFXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:35:46 -0400
Date: Fri, 6 Apr 2012 16:35:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Metcalf <cmetcalf@tilera.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] hugetlb: fix race condition in hugetlb_fault()
In-Reply-To: <20120406162618.3307a9bd.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1204061631160.3820@eggly.anvils>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com> <CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com> <201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com> <CAJd=RBBWx7uZcw=_oA06RVunPAGeFcJ7LY=RwFCyB_BreJb_kg@mail.gmail.com>
 <4F7887A5.3060700@tilera.com> <20120406152305.59408e35.akpm@linux-foundation.org> <alpine.LSU.2.00.1204061601370.3637@eggly.anvils> <20120406162618.3307a9bd.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andrew Morton wrote:
> On Fri, 6 Apr 2012 16:10:13 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> > 
> > The resulting patch is okay; but let's reassure Chris that his
> > original patch was better, before he conceded to make the get_page
> > and put_page unconditional, and added unnecessary detail of the race.
> > 
> 
> Yes, the v1 patch was better.  No reason was given for changing it?

I think Chris was aiming to be a model citizen, and followed review
suggestions that he would actually have done better to resist.

Hugh
