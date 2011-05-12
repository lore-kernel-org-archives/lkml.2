Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1ELSqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:46:55 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:21548 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757667Ab1ELSqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:46:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gf20SVsVM1mCmSGgIRPolRoUREbtKn2zsl8WU9KFjRPR415
 gNsS89UVZAPcV6dHNgnuDn0uvwkNLydTfE4vqjV8CugU7MnCWQ.L6HqtQ2Um
 TilxFKG5fkEhMNvI5Sd1yytIS1ltJ2MtUXAtf2CupSyzsoY6IkMxkxGjnz8r
 UdKzzhm1ikmQdWpPsmn3U4.XAOjxtt9T4PK8zCqfljyU8l.ZeL7YR7S.3D1B
 PCc86PiQh8MW3aJ1jjRBXYWTqrknbkXdyAySbyGS41fcCLJYC7eAsDvxKLho
 ClZB1OFqFbewIIelMLIjGC5nRYvaWde7vUHUfmVf5dcOgXThG
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 13:46:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305225467.2575.66.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105121345450.29359@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>  <1305127773-10570-4-git-send-email-mgorman@suse.de>  <alpine.DEB.2.00.1105120942050.24560@router.home>  <1305213359.2575.46.camel@mulgrave.site>  <alpine.DEB.2.00.1105121024350.26013@router.home>
  <1305214993.2575.50.camel@mulgrave.site> <1305215742.27848.40.camel@jaguar> <1305225467.2575.66.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, James Bottomley wrote:

> On Thu, 2011-05-12 at 18:55 +0300, Pekka Enberg wrote:
> > On Thu, 2011-05-12 at 10:43 -0500, James Bottomley wrote:
> > > However, since you admit even you see problems, let's concentrate on
> > > fixing them rather than recriminations?
> >
> > Yes, please. So does dropping max_order to 1 help?
> > PAGE_ALLOC_COSTLY_ORDER is set to 3 in 2.6.39-rc7.
>
> Just booting with max_slab_order=1 (and none of the other patches
> applied) I can still get the machine to go into kswapd at 99%, so it
> doesn't seem to make much of a difference.

slub_max_order=1 right? Not max_slab_order.
