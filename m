Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1HKNrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:47:02 -0400
Received: from gw1.transmode.se ([195.58.98.146]:50136 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1HKNq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:46:59 -0400
In-Reply-To: <4E4309E4.2080108@systemfabricworks.com>
References: <20110810222018.281901163@systemfabricworks.com> <4E4309E4.2080108@systemfabricworks.com>
Subject: Re: [patch v5 7/8] crc32-add-slicing-by-8.diff
X-KeepSent: F6AD0859:4077A7BE-C12578E9:004B9F2C;
 type=4; name=$KeepSent
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFF6AD0859.4077A7BE-ONC12578E9.004B9F2C-C12578E9.004BB62C@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 11 Aug 2011 15:46:58 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/11/2011 15:46:58
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/08/11 00:44:52:
>
> extend add slicing-by-8 algorithm to the existing
> slicing-by-4 algorithm. This consists of:
>
>    - extend largest BITS size from 32 to 64
>    - extend table from tab[4][256] to tab[8][256]
>    - change algorithm to align on 8 byte boundary
>      (it was noted that all that is really required
>      is that the inner loop must comsume 8 bytes.
>      As written it can start on even or odd 4 byte
>      boundary.)
>    - Add code for inner loop.
>
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
>
> ---
>  lib/crc32.c          |   60 ++++++++++++++++++++++++++++++++++++++++++---------
>  lib/crc32defs.h      |   14 +++++------
>  lib/gen_crc32table.c |   40 ++++++++++++++++++++--------------

While looking at gen_crc32table.c I see that much of my remarks still stands

