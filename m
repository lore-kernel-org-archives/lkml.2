Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1IFTjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:39:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab1IFTjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:39:06 -0400
Date: Tue, 6 Sep 2011 12:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        fzago@systemfabricworks.com, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org,
        Bob Pearson <rpearson@systemfabricworks.com>
Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
Message-Id: <20110906123851.dc4de9f5.akpm@linux-foundation.org>
In-Reply-To: <20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au>
References: <20110831213729.395283830@systemfabricworks.com>
	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org>
	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>
	<20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011 00:50:13 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi,
> 
> On Tue, 6 Sep 2011 15:40:10 +0200 Joakim Tjernlund <joakim.tjernlund@transmode.se> wrote:
> >
> > It seems like an early version of the slice-by-8 crc32 algo. is in linux-next,
> > committed by you.
> > That version is crap, whats the plan?
> 
> I assume that it is one of the patches in Andrew's tree. When things get
> back closer to normality with kernel.org, I assume that Andrew will
> replace it with a newer version (if he has been sent one).

Yup.  lib-crc-add-slice-by-8-algorithm-to-crc32c.patch is dead meat.  I
sometimes keep things like that around to get them a bit of testing
while reminding myself that there's an open issue to track.

