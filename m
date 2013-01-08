Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3AHPDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:03:25 -0500
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:36008 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3AHPDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:03:24 -0500
Message-Id: <50EC4345020000A10000E5D1@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 08 Jan 2013 16:03:17 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: "Yuanhan Liu" <yuanhan.liu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Cc: "Mike Christie" <michaelc@cs.wisc.edu>,
        "iscsi list" <open-iscsi@googlegroups.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Stefani Seibold" <stefani@seibold.net>
Subject: Antw: [PATCH 0/5] kfifo cleanup and log based kfifo API
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Yuanhan Liu <yuanhan.liu@linux.intel.com> schrieb am 08.01.2013 um 15:57 in
Nachricht <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>:

[...]
> My proposal is to replace kfifo_init with kfifo_alloc, where it
> allocate buffer and maintain fifo size inside kfifo. Then we can
> remove buggy kfifo_init.
[...]

Spontaneously I feel that emitting a critical message if the requested size is not a power of two would be a good idea, as well as (in that case) rounding up to the next power of two instead of rounding down seems not too stupid ;-)

Sorry, I'm not deeply into recent kernel development.

Regards,
Ulrich


