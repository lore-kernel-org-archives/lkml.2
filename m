Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab1CXUCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:02:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847Ab1CXUB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:01:58 -0400
Date: Thu, 24 Mar 2011 21:01:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324200139.GC7957@elte.hu>
References: <1300990853.3747.189.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103241346060.32226@router.home>
 <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
 <20110324185903.GA30510@elte.hu>
 <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
 <alpine.DEB.2.00.1103241404490.5576@router.home>
 <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
 <20110324193647.GA7957@elte.hu>
 <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>
 <alpine.DEB.2.00.1103241451060.5576@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103241451060.5576@router.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_00,URIBL_RHS_DOB autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	1.5 URIBL_RHS_DOB          Contains an URI of a new domain (Day Old Bread)
	[URIs: linux.com]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 24 Mar 2011, Pekka Enberg wrote:
> 
> > Thanks, Ingo! Christoph, may I have your sign-off for the patch and
> > I'll send it to Linus?
> 
> 
> Subject: SLUB: Write to per cpu data when allocating it

The commit title should obviously start with "SLUB: Fix boot crash ..."

Thanks,

	Ingo
