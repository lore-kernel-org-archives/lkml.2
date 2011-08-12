Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab1HLHyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:54:21 -0400
Received: from gw1.transmode.se ([195.58.98.146]:36687 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1HLHyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:54:20 -0400
In-Reply-To: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com>
References: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com>
Subject: Re: [patch v5 resending 0/8] Add slicing-by-8 to crc32
X-KeepSent: 79B4FA74:153E98FD-C12578EA:0021A784;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Fri, 12 Aug 2011 08:39:44 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/12/2011 08:39:44
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/11 19:52:01:
>
> Resending the patch series by hand. I have been having a lot of problems
> trying to
> Figure out how to make quilt and thunderbird play together. Please let me
> Know of this one is better. I have never been able to get quilt to
> Make a mbox that my thunderbird likes but Frank has been able to do it.
> The last time I imported a mbox into thunderbird as Unsent Messages and then
> Edited each note and typed send but for some reason there was a lot of
> breakage.
> This time I just used the external editor to read in each patch from the
> patches
> Directory one a time.

I am not even going to try. After a quick look the still look broken and
several my earlier remarks appears to be ignored.
The changes to gen_crc32table.c looks random, where did this come from
(in v5 6/8):
 -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][256];
+static uint32_t crc32table_be[4][256];

 Jocke

