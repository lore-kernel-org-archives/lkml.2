Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2DQFdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:33:12 -0400
Received: from gw1.transmode.se ([195.58.98.146]:42718 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2DQFdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:33:11 -0400
In-Reply-To: <1334624440.25353.18.camel@pasglop>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca>	 <CACxGe6u7EUYqyZ_8tC8PFRHwS+xq7u9+fCJk+UFbrtrV-YJFvQ@mail.gmail.com>
	 <1334617419.25353.15.camel@pasglop>	 <OFAAF4BF26.BF8400B2-ONC12579E2.008226AC-C12579E3.00005051@transmode.se> <1334624440.25353.18.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt
 controller
X-KeepSent: E9765BBA:C01624AC-C12579E3:001E58A0;
 type=4; name=$KeepSent
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFE9765BBA.C01624AC-ONC12579E3.001E58A0-C12579E3.001E7F8B@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 17 Apr 2012 07:33:07 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 17/04/2012 07:33:07
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 2012/04/17 03:00:40:
>
> On Tue, 2012-04-17 at 02:03 +0200, Joakim Tjernlund wrote:
> >
> > If you are going to test 8xx, could you revert
> > e0908085fc2391c85b85fb814ae1df377c8e0dcb,
> > powerpc/8xx: Fix regression introduced by cache coherency rewrite ?
> >
> > It should not be needed after I fixed up the 8xx TLB code and added a
> > workaround
> > for buggy dcbX instructions.
>
> Have you actually verified that things still work after reverting it ?

Nope, I haven't moved our 8xx to 3.x. We are still on
2.4 and it works there.

 Jocke

