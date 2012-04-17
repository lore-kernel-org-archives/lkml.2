Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2DQAKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:10:43 -0400
Received: from gw1.transmode.se ([195.58.98.146]:40575 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2DQAKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:10:42 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 20:10:42 EDT
In-Reply-To: <1334617419.25353.15.camel@pasglop>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca> <CACxGe6u7EUYqyZ_8tC8PFRHwS+xq7u9+fCJk+UFbrtrV-YJFvQ@mail.gmail.com> <1334617419.25353.15.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt
 controller
X-KeepSent: AAF4BF26:BF8400B2-C12579E2:008226AC;
 type=4; name=$KeepSent
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFAAF4BF26.BF8400B2-ONC12579E2.008226AC-C12579E3.00005051@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 17 Apr 2012 02:03:25 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 17/04/2012 02:03:25
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:
> > Ben, I can take these two patches via my irqdomain tree if you prefer.
>
> Let me give them a test run first.

Hi Ben

If you are going to test 8xx, could you revert e0908085fc2391c85b85fb814ae1df377c8e0dcb,
powerpc/8xx: Fix regression introduced by cache coherency rewrite ?

It should not be needed after I fixed up the 8xx TLB code and added a workaround
for buggy dcbX instructions.

 Jocke

