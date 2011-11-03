Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1KCKSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:18:40 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:39785
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab1KCKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:18:39 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1803M103dK1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LU2XYU-02-4TE-02
X-M-MSG: 
Date: Thu, 3 Nov 2011 11:18:29 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Robin Holt <holt@sgi.com>, Rik van Riel <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [RFC][PATCH 0/3] Add support for non-CPU TLBs in MMU-Notifiers
Message-ID: <20111103101829.GR13244@amd.com>
References: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
 <20111102094601.GN28536@sgi.com>
 <20111102095740.GM13244@amd.com>
 <20111103000725.GD18879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111103000725.GD18879@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 08:07:25PM -0400, Andrea Arcangeli wrote:
> On Wed, Nov 02, 2011 at 10:57:40AM +0100, Roedel, Joerg wrote:
> > I have included this mailing list in my post afaics. I talked with
> > Andrea Arcangeli about these patches at LinuxCon in Prague and will post
> > a new version based on his comments.
> 
> Thanks!
> Andrea
> 
> PS. Luckily I already read your patches before we met :).

Yeah, otherwise we would have done some kind of peer-review ;)


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

