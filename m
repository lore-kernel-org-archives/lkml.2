Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1CWH3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:29:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46079 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1CWH33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:29:29 -0400
Message-ID: <4D89A157.4090600@kernel.dk>
Date: Wed, 23 Mar 2011 08:29:27 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/iostats.txt: bit-size reference etc.
References: <4D83D188.3000909@tlinx.org> <alpine.LFD.2.00.1103221509030.20572@chimera.site>
In-Reply-To: <alpine.LFD.2.00.1103221509030.20572@chimera.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 23:10, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> - correction that disk stats values are native-word-sized
>   32-bit or 64-bit values, not always 32-bi values
> - drop "Last modified" entry; use git for that
> - fix a few typos
> - change "cpu" to "CPU"

Randy, this one doesn't apply at all:

patching file Documentation/iostats.txt
Hunk #1 FAILED at 1.
Hunk #2 FAILED at 46.
Hunk #3 FAILED at 96.

-- 
Jens Axboe

