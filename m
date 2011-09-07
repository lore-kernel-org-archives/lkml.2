Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1IGRF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:05:58 -0400
Received: from gw1.transmode.se ([195.58.98.146]:54735 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab1IGRFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:05:10 -0400
In-Reply-To: <02a401cc6cd2$28ee4e60$7acaeb20$@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org>	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>	<20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au> <20110906123851.dc4de9f5.akpm@linux-foundation.org> <02a401cc6cd2$28ee4e60$7acaeb20$@systemfabricworks.com>
Subject: RE: [PATCH v6 05/10] crc32-misc-cleanup.diff
X-KeepSent: 2CB0F7C7:DAD4E211-C1257904:00299258;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, fzago@systemfabricworks.com,
        "'George Spelvin'" <linux@horizon.com>, linux-kernel@vger.kernel.org,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF2CB0F7C7.DAD4E211-ONC1257904.00299258-C1257904.002A1865@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 7 Sep 2011 09:39:47 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/07/2011 09:39:48
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/09/06 22:18:35:
>
> >
> > Yup.  lib-crc-add-slice-by-8-algorithm-to-crc32c.patch is dead meat.  I
> > sometimes keep things like that around to get them a bit of testing
> > while reminding myself that there's an open issue to track.
>
> I thought I was getting close until recently someone sent out a patch set
> for crc32c.c, the other 32 bit CRC in common use, based on an earlier
> version of the changes we have been working on for crc32.c. This has brought
> in other interested parties and created a bit of duplicated code. I am at a
> loss as to the best way to proceed. Personally I would like to see this
> change go upstream and then let the rest of the world figure out how to best
> merge things.

The crc32c code should be moved to lib and integrated into crc32.c. Then you get
all the optimizations for free. It think the new crypto crc32c code should just
be nacked.

 Jocke

