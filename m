Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1CQWzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:55:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43265 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:55:43 -0400
Date: Thu, 17 Mar 2011 23:55:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317225541.GK11094@one.firstfloor.org>
References: <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com> <20110317062612.GE11094@one.firstfloor.org> <4D81BB87.10803@jp.fujitsu.com> <20110317140401.GX10696@random.random> <20110317152559.GG11094@one.firstfloor.org> <20110317161219.GZ10696@random.random> <20110317162710.GH11094@one.firstfloor.org> <20110317164726.GA10696@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317164726.GA10696@random.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I meant the testsuite using MCE injection, called mce-test. I've run
> it a couple of times for some hugetlbfs collision with THP (solved
> some time ago).

This won't hit small code windows like that.

> I'm unsure if there's already coverage for it in mce-test yet, the
> biggest test I run was hugetlbfs related (MAP_ANONYMOUS|MAP_HUGETLB or
> filebacked or still shm). Surely it'd be good idea to add THP
> coverage.

Sounds like a good idea. Feel free to contribute a test case.
-Andi
