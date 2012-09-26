Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2IZFsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:48:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2IZFsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:48:18 -0400
Message-ID: <50629719.2010107@kernel.dk>
Date: Wed, 26 Sep 2012 07:48:09 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 1/2] Fix a crash when block device is read and block size
 is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> <1343508252.2626.13184.camel@edumazet-glaptop> <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop> <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com> <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com> <Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com> <x49liguyg6r.fsf@segfault.boston.devel.redhat.com> <x49wqzswdn3.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com> <x49ehlzrt01.fsf@segfault.boston.devel.redhat.com> <x49sja6ouv4.fsf@segfault.boston.devel.redhat.com> <5061F0E6.5000403@kernel.dk> <5061F3D2.6050502@kernel.dk> <Pine.LNX.4.64.1209251847340.21075@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1209251847340.21075@file.rdu.redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-26 00:49, Mikulas Patocka wrote:
> Here I'm resending it as two patches. The first one uses existing 
> semaphore, the second converts it to RCU-based percpu semaphore.

Thanks, applied. In the future, please send new patch 'series' as a new
thread instead of replying to some email in the middle of an existing
thread. It all becomes very messy pretty quickly. Patch #2 had a botched
subject line, so that didn't help either :-)

-- 
Jens Axboe

