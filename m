Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2KPWCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab2KPWCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:02:53 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 1/2] Fix a crash when block device is read and block size is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
	<x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
	<x49ehlzrt01.fsf@segfault.boston.devel.redhat.com>
	<x49sja6ouv4.fsf@segfault.boston.devel.redhat.com>
	<5061F0E6.5000403@kernel.dk> <5061F3D2.6050502@kernel.dk>
	<Pine.LNX.4.64.1209251847340.21075@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 16 Nov 2012 17:02:37 -0500
In-Reply-To: <Pine.LNX.4.64.1209251847340.21075@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Tue, 25 Sep 2012 18:49:19 -0400 (EDT)")
Message-ID: <x4939096waq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> blockdev: fix a crash when block size is changed and I/O is issued simultaneously
>
> The kernel may crash when block size is changed and I/O is issued
> simultaneously.

Mikulas, do you plan to submit a variant of this for stable as well?

Cheers,
Jeff
