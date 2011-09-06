Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1IFNkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:40:18 -0400
Received: from gw1.transmode.se ([195.58.98.146]:50750 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1IFNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:40:14 -0400
In-Reply-To: <20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org> <20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
X-KeepSent: 0B1D5F8A:D8D66C8A-C1257903:004A257F;
 type=4; name=$KeepSent
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, fzago@systemfabricworks.com,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        Bob Pearson <rpearson@systemfabricworks.com>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 6 Sep 2011 15:40:10 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/06/2011 15:40:12
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2011/09/03 03:44:03:
>
> On Fri, 2 Sep 2011 16:50:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Sure, these these things may be accidentally dragged in via nested
> > includes but it's bad to depend upon that - such things regularly cause
> > breakage when configs are changed.
>
> And even the same config on different architectures or platforms.  That's
> why we have Rule 1 in Documentation/SubmitChecklist ...

It seems like an early version of the slice-by-8 crc32 algo. is in linux-next,
committed by you.
That version is crap, whats the plan?

