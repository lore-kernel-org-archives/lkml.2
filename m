Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2DSBbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:31:34 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:52302 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DSBb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:31:27 -0400
From: "W. Trevor King" <wking@tremily.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "W. Trevor King" <wking@tremily.us>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] staging: comedi: ni_tio_internal.h: checkpatch.pl
 cleanups
Date: Wed, 18 Apr 2012 21:30:26 -0400
Message-id: <cover.1334798829.git.wking@tremily.us>
X-Mailer: git-send-email 1.7.3.4
In-reply-to: <20120418235714.GC5163@kroah.com>
References: <20120418235714.GC5163@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:57:14PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Apr 17, 2012 at 09:59:35AM -0400, W. Trevor King wrote:
> > * Line wrapping to stay under 80 characters.
> > * No braces for single statement blocks.
>
> Please break this into 2 different patches.

Here you go.

> Only do one thing per patch, that's the correct thing to do.

Sorry, I was thinking "fix checkpatch.pl issues" was a single thing.  I
was also thinking that this is the kind of dumb change that has to happen,
but makes walking backwards with `git blame` annoying, so it would be
better to compress it into fewer commits ;).


W. Trevor King (2):
  staging: comedi: ni_tio_internal.h: checkpatch.pl line wrapping
  staging: comedi: ni_tio_internal.h: checkpatch.pl cleanups

 drivers/staging/comedi/drivers/ni_tio_internal.h |   36 +++++++++++++--------
 1 files changed, 22 insertions(+), 14 deletions(-)

-- 
1.7.3.4

